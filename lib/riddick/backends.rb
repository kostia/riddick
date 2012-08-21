require 'i18n'

module Riddick
  module Backends
    class << self
      def simple
        backends.find { |be| be.kind_of? I18n::Backend::Simple }
      end

      def key_value
        backends.find { |be| be.kind_of? I18n::Backend::KeyValue }
      end

      private

      def backends
        I18n.backend.backends
      end
    end
  end
end
