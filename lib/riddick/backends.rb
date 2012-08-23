require 'i18n'

module Riddick
  module Backends
    class << self
      attr_writer :simple, :key_value

      def simple
        @simple ||= backends.find { |be| be.kind_of? I18n::Backend::Simple }
      end

      def key_value
        @key_value ||= backends.find { |be| be.kind_of? I18n::Backend::KeyValue }
      end

      private

      def backends
        I18n.backend.backends
      end
    end
  end
end
