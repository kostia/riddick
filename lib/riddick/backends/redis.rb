module Riddick
  module Backends
    class Redis < Riddick::Backends::KeyValue
      def delete_translation(k)
        store.del k
      end

      def translations
        keys = store.keys
        if keys.any?
          Hash[keys.zip store.mget(keys).map { |v| Riddick::Backends::Redis::Value.new v }]
        else
          {}
        end
      end

      private

      def store
        @i18n_backend.store
      end
    end
  end
end
