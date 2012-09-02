module Riddick
  module Backends
    # Redis based key-value backend.
    class Redis < Riddick::Backends::KeyValue
      # Delete a translation from the store.
      def delete_translation(k)
        store.del k
      end

      # Fetch and return custom translation as a hash of type: {'en.foo.bar' => 'baz'}.
      # Values of the hash are of kind Riddick::Backends::Redis::Value, so it's easy
      # to determine whether they are custom translation or the predefined.
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
