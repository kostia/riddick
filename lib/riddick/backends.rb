module Riddick
  module Backends
    class << self
      attr_writer :chain, :simple, :key_value

      def simple
        @simple ||= Riddick::Backends::Simple.new(
            chain.backends.find { |be| be.kind_of? I18n::Backend::Simple })
      end

      def key_value
        @key_value ||= Riddick::Backends::Redis.new(
            chain.backends.find { |be| be.kind_of? I18n::Backend::KeyValue })
      end

      def chain
        @chain ||= I18n.backend
      end

      def store_translation(key, value)
        locale, *parts = key.split '.'
        chain.store_translations locale, {parts.join('.') => value}, escape: false
      end

      def delete_translation(key)
        key_value.delete_translation key
      end
    end
  end
end
