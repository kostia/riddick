require 'riddick/backends/key_value'

module Riddick
  module Backends
    class Redis < Riddick::Backends::KeyValue
      def delete_translation(key)
        store.del key
      end

      def translations
        keys = store.keys
        keys.any? ? Hash[keys.zip store.mget(keys)] : {}
      end

      private

      def store
        @i18n_backend.store
      end
    end
  end
end
