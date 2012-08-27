require 'i18n'

module Riddick
  module Backends
    class Simple
      def initialize(i18n_backend)
        @i18n_backend = i18n_backend
      end

      def translations
        Hash[@i18n_backend.send(:translations)[I18n.locale].riddick_normalize]
      end

      def init_translations
        @i18n_backend.send :init_translations
      end
    end
  end
end
