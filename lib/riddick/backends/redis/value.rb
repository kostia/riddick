module Riddick
  module Backends
    class Redis < Riddick::Backends::KeyValue
      # Generic value for Redis backend.
      class Value < Riddick::Backends::KeyValue::Value
      end
    end
  end
end
