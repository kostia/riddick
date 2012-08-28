module Riddick
  module Backends
    class KeyValue
      class Value
        def initialize(string)
          @object = MultiJson.decode string
        end

        def to_s
          @object.to_s
        end
      end
    end
  end
end
