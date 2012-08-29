require 'spec_helper'

describe Riddick::Backends do
  describe '#chain' do
    context 'when not set via setter method' do
      it 'should return I18n backend chain' do
        Riddick::Backends.chain.should == I18n.backend
      end
    end

    context 'when set via setter method' do
      it 'should return the chain object' do
        chain = mock
        Riddick::Backends.chain = chain
        Riddick::Backends.chain.should == chain
      end
    end
  end

  describe '#simple' do
    let(:kv_be) { I18n::Backend::KeyValue.new({}) }
    let(:s_be) { I18n::Backend::Simple.new }
    let(:chain) { mock backends: [kv_be, s_be] }

    before do
      Riddick::Backends.chain = chain
    end

    context 'when no set via setter method' do
      it 'should determine backend dynamically' do
        Riddick::Backends.simple.should be_kind_of(Riddick::Backends::Simple)
        Riddick::Backends.simple.i18n_backend.should == s_be
      end
    end

    context 'when set via setter method' do
      it 'should return the backend object' do
        Riddick::Backends.simple = s_be
        Riddick::Backends.simple.should == s_be
      end
    end
  end

  describe '#key_value' do
    let(:kv_be) { I18n::Backend::KeyValue.new({}) }
    let(:s_be) { I18n::Backend::Simple.new }
    let(:chain) { mock backends: [kv_be, s_be] }

    before do
      Riddick::Backends.chain = chain
    end

    context 'when no set via setter method' do
      it 'should determine backend dynamically' do
        Riddick::Backends.key_value.should be_kind_of(Riddick::Backends::Redis)
        Riddick::Backends.key_value.i18n_backend.should == kv_be
      end
    end

    context 'when set via setter method' do
      it 'should return the backend object' do
        Riddick::Backends.key_value = kv_be
        Riddick::Backends.key_value.should == kv_be
      end
    end
  end

  describe '#store_translation' do
    it 'should store unescaped translation in chain with correctly determined path' do
      chain = mock
      Riddick::Backends.chain = chain
      chain.should_receive(:store_translations).with 'en', {'foo.bar' => 'baz'}, {escape: false}
      Riddick::Backends.store_translation 'en.foo.bar', 'baz'
    end
  end

  describe '#delete_translation' do
    it 'should delete translation from key value backend' do
      kv_be = mock
      Riddick::Backends.key_value = kv_be
      kv_be.should_receive(:delete_translation).with 'foo.bar'
      Riddick::Backends.delete_translation 'foo.bar'
    end
  end
end
