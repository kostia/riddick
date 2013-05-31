module Riddick
  # Main interface for the server to interoperate with I18n the backends.
  module Backend
    class << self
      attr_writer :chain, :simple, :key_value

      # Return a Riddick::Backend::Simple wrapped around a I18n::Backend::Simple.
      # It iterates over the backends in the chain and takes the first one found of required type.
      def simple
        @simple ||= Riddick::Backend::Simple.new(find_backend(I18n::Backend::Simple))
      end

      # Return a Riddick::Backend::Redis wrapped around a I18n::Backend::KeyValue.
      # It iterates over the backends in the chain and takes the first one found of required type.
      def key_value
        @key_value ||= Riddick::Backend::Redis.new(find_backend(I18n::Backend::KeyValue))
      end

      # Returns the chain. By default it's I18n.backend (which is assumed to be a I18n::Backend::Chain).
      def chain
        @chain ||= I18n.backend
      end

      # Stores a translation in the chain.
      def store_translation(key, value)
        locale, *parts = key.split '.'
        chain.store_translations locale, {parts.join('.') => value}, escape: false
      end

      # Deletes a translation from the key-value backend.
      def delete_translation(key)
        key_value.delete_translation key
      end

      private

      def find_backend(base_class)
        chain.backends.find { |be| be.kind_of?(base_class) }
      end
    end
  end
end
