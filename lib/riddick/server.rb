require 'i18n'
require 'sinatra'

require 'riddick/backends'
require 'riddick/hash'
require 'riddick/version'

module Riddick
  class Server < Sinatra::Base
    Riddick::Backends.simple.init_translations

    helpers do
      def url(*parts)
        [request.script_name, parts].join('/').squeeze('/')
      end
    end

    get '/' do
      @predefined_translations = Riddick::Backends.simple.translations
      @custom_translations = Riddick::Backends.key_value.translations
      erb :index
    end

    post '/set' do
      key, value = params[:key], params[:value]
      Riddick::Backends.store_translation(key, value) if key && !key.empty? && value && !value.empty?
      redirect url('/')
    end

    get '/del' do
      key = params[:key]
      Riddick::Backends.delete_translation(key) if key && !key.empty?
      redirect url('/')
    end
  end
end
