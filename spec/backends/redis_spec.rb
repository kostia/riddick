require 'spec_helper'

describe Riddick::Backends::Redis do
  describe 'creating a new backend' do
    it 'should be a key value backend' do
      Riddick::Backends::Redis.new(mock).should be_kind_of(Riddick::Backends::KeyValue)
    end

    it 'should store i18n backend' do
      i18n_be = mock
      Riddick::Backends::Redis.new(i18n_be).i18n_backend.should == i18n_be
    end
  end

  describe '#translations' do
    describe 'if there are any keys' do
      it 'should return the translation hash' do
        redis_be = mock(store: mock(keys: %w[k1 k2 k3]))
        redis_be.store.should_receive(:mget).with(%w[k1 k2 k3]).and_return %w["v1" "v2" "v3"]
        translations = Riddick::Backends::Redis.new(redis_be).translations
        translations.size.should == 3
        translations['k1'].should be_a(Riddick::Backends::Redis::Value)
        translations['k1'].to_s.should == 'v1'
        translations['k2'].should be_a(Riddick::Backends::Redis::Value)
        translations['k2'].to_s.should == 'v2'
        translations['k3'].should be_a(Riddick::Backends::Redis::Value)
        translations['k3'].to_s.should == 'v3'
      end
    end

    describe 'if there are no keys' do
      it 'should return an empty hash' do
        redis_be = mock(store: mock(keys: []))
        Riddick::Backends::Redis.new(redis_be).translations.should == {}
      end
    end
  end

  describe '#delete_translation' do
    it 'should delete key from the store' do
      redis_be = mock store: mock
      redis_be.store.should_receive(:del).with 'foo.bar'
      Riddick::Backends::Redis.new(redis_be).delete_translation 'foo.bar'
    end
  end

  describe Riddick::Backends::Redis::Value do
    it 'should be a general key value value' do
      v = Riddick::Backends::Redis::Value.new '"foo"'
      v.should be_kind_of(Riddick::Backends::KeyValue::Value)
    end

    it 'should return decoded string' do
      v = Riddick::Backends::Redis::Value.new MultiJson.encode('foo')
      v.to_s.should == 'foo'

      v = Riddick::Backends::Redis::Value.new MultiJson.encode(%w[foo bar baz])
      v.to_s.should == '["foo", "bar", "baz"]'
    end
  end
end
