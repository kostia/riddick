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
end
