require 'spec_helper'

describe Riddick::Backend::KeyValue do
  describe 'creating a new backend' do
    it 'should store i18n backend' do
      i18n_be = mock
      Riddick::Backend::KeyValue.new(i18n_be).i18n_backend.should == i18n_be
    end
  end

  describe Riddick::Backend::KeyValue::Value do
    it 'should return decoded string' do
      v = Riddick::Backend::KeyValue::Value.new MultiJson.encode('foo')
      v.to_s.should == 'foo'

      v = Riddick::Backend::KeyValue::Value.new MultiJson.encode(%w[foo bar baz])
      v.to_s.should == '["foo", "bar", "baz"]'
    end
  end
end
