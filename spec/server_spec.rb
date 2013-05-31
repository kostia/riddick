require 'rack/test'
require 'spec_helper'

set :environment, :test

describe 'Riddick::Server', type: :request do
  include Rack::Test::Methods

  def app
    Riddick::Server.new
  end

  let(:s_be) { mock }
  let(:kv_be) { mock }

  before do
    Riddick::Backend.simple = s_be
    Riddick::Backend.key_value = kv_be

    s_be.should_receive :init_translations # Assert translations are initialized on load

    load 'lib/riddick/server.rb'

    s_be.stub(:translations).and_return({
      'en.k1' => 'default-v1',
      'en.k2' => 'default-v2',
    })
    kv_be.stub(:translations).and_return({
      'en.k2' => Riddick::Backend::Redis::Value.new('"my-v2"'),
      'en.k3' => Riddick::Backend::Redis::Value.new('"my-v3"'),
    })
  end

  describe 'GET /' do
    it 'should render list of all translations overlaying default with my' do
      get '/'
      last_response.should be_ok
      last_response.body.should have_selector("option[value='en.k1'][data-v='default-v1']")
      last_response.body.should have_selector("option[value='en.k2'][data-v='my-v2']")
      last_response.body.should have_selector("option[value='en.k3'][data-v='my-v3']")
    end
  end

  describe 'GET /my' do
    it 'should render list of my translations' do
      get '/my'
      last_response.should be_ok
      last_response.body.should_not have_selector("option[data-v^='default-']")
      last_response.body.should have_selector("option[value='en.k2'][data-v='my-v2']")
      last_response.body.should have_selector("option[value='en.k3'][data-v='my-v3']")
    end
  end

  describe 'GET /default' do
    it 'should render list of default translations' do
      get '/default'
      last_response.should be_ok
      last_response.body.should_not have_selector("option[data-v^='my-']")
      last_response.body.should have_selector("option[value='en.k1'][data-v='default-v1']")
      last_response.body.should have_selector("option[value='en.k2'][data-v='default-v2']")
    end
  end

  describe 'POST /set' do
    context 'with valid params' do
      it 'should store translation and redirect to my translation' do
        Riddick::Backend.should_receive(:store_translation).with 'en.k1', 'my-v1' do
          kv_be.stub(:translations).and_return({
            'en.k1' => Riddick::Backend::Redis::Value.new('"my-v1"'),
            'en.k2' => Riddick::Backend::Redis::Value.new('"my-v2"'),
            'en.k3' => Riddick::Backend::Redis::Value.new('"my-v3"'),
          })
        end
        post '/set', k: 'en.k1', v: 'my-v1'
        follow_redirect!
        last_response.should be_ok
        last_response.body.should_not have_selector("option[data-v^='default-']")
        last_response.body.should have_selector("option[value='en.k1'][data-v='my-v1']")
        last_response.body.should have_selector("option[value='en.k2'][data-v='my-v2']")
        last_response.body.should have_selector("option[value='en.k3'][data-v='my-v3']")
      end
    end

    context 'with incorrect params' do
      it 'should not try to store translation and render index' do
        Riddick::Backend.should_not_receive :store_translation

        post '/set', k: 'en.k1', v: ''
        follow_redirect!
        last_response.should be_ok
        last_response.body.should have_selector("option[value='en.k2'][data-v='my-v2']")
        last_response.body.should have_selector("option[value='en.k3'][data-v='my-v3']")

        post '/set', k: '', v: 'my-v1'
        follow_redirect!
        last_response.should be_ok
        last_response.body.should have_selector("option[value='en.k2'][data-v='my-v2']")
        last_response.body.should have_selector("option[value='en.k3'][data-v='my-v3']")
      end
    end
  end

  describe 'GET /del' do
    context 'with valid key' do
      it 'should delete translation and redirect root' do
        Riddick::Backend.should_receive(:delete_translation).with 'en.k2' do
          kv_be.stub(:translations).and_return({
            'en.k3' => Riddick::Backend::Redis::Value.new('"my-v3"'),
          })
        end
        get '/del', k: 'en.k2'
        follow_redirect!
        last_response.should be_ok
        last_response.body.should have_selector("option[value='en.k1'][data-v='default-v1']")
        last_response.body.should have_selector("option[value='en.k2'][data-v='default-v2']")
        last_response.body.should have_selector("option[value='en.k3'][data-v='my-v3']")
      end
    end

    context 'with invalid key' do
      it 'should delete translation and redirect root' do
        Riddick::Backend.should_not_receive :delete_translation
        get '/del', k: ''
        follow_redirect!
        last_response.should be_ok
        last_response.body.should have_selector("option[value='en.k1'][data-v='default-v1']")
        last_response.body.should have_selector("option[value='en.k2'][data-v='my-v2']")
        last_response.body.should have_selector("option[value='en.k3'][data-v='my-v3']")
      end
    end
  end
end
