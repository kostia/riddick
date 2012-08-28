module Riddick
  module Backends
    class Simple
      attr_reader :i18n_backend

      def initialize(i18n_backend)
        @i18n_backend = i18n_backend
      end

      def translations
        @i18n_backend.send(:translations)[I18n.locale].riddick_normalize I18n.locale
      end

      def init_translations
        @i18n_backend.send :init_translations
      end
    end
  end
end
