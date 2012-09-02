module Riddick
  module Backends
    # Wrapper aroud I18n::Backend::Simple.
    class Simple
      attr_reader :i18n_backend

      def initialize(i18n_backend)
        @i18n_backend = i18n_backend
      end

      # Calculate and return the default translations as a hash of type:
      # {'en.foo.bar' => 'baz!'}
      def translations
        @i18n_backend.send(:translations)[I18n.locale].riddick_normalize_i18n I18n.locale
      end

      # Ensure the translations are loaded.
      def init_translations
        @i18n_backend.send :init_translations
      end
    end
  end
end
