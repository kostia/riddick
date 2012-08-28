require 'spec_helper'

describe Hash do
  describe '#riddick_normalize_i18n' do
    it 'should return i18n-style hash' do
      {
        foo: {
          bar: 'baz',
          blub: 'bla',
        }
      }.riddick_normalize_i18n('en').should == {'en.foo.bar' => 'baz', 'en.foo.blub' => 'bla'}
    end
  end
end
