require 'spec_helper'

describe Riddick::Backends::Simple do
  describe 'creating a new backend' do
    it 'should store i18n backend' do
      i18n_be = mock
      Riddick::Backends::Simple.new(i18n_be).i18n_backend.should == i18n_be
    end
  end

  describe '#translations' do
    it 'should return normalized translation from i18n backend' do
      I18n.stub(:locale).and_return :en
      i18n_be = mock translations: {en: {'foo' => {'bar' => 'baz'}}}
      Riddick::Backends::Simple.new(i18n_be).translations.should == {'en.foo.bar' => 'baz'}
    end
  end

  describe '#init_translations' do
    it 'should init translations of i18n backend' do
      i18n_be = mock
      i18n_be.should_receive :init_translations
      Riddick::Backends::Simple.new(i18n_be).init_translations
    end
  end
end
