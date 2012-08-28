module Riddick
  module Backends
    class KeyValue
      attr_reader :i18n_backend

      def initialize(i18n_backend)
        @i18n_backend = i18n_backend
      end
    end
  end
end
