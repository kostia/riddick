module Riddick
  module Backends
    class KeyValue
      # Generic value class. Purpose is to determine whether a value is
      # a custom translation or predefined.
      class Value
        def initialize(string)
          @object = MultiJson.decode string
        end

        # Render the underlaying object (used in the GUI).
        def to_s
          @object.to_s
        end
      end
    end
  end
end
