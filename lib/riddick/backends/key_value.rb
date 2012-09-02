module Riddick
  module Backends
    # Generic key-value backend (for custom translations).
    class KeyValue
      attr_reader :i18n_backend

      def initialize(i18n_backend)
        @i18n_backend = i18n_backend
      end
    end
  end
end
