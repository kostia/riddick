module Riddick
  module Backend
    class Redis < Riddick::Backend::KeyValue
      # Generic value for Redis backend.
      class Value < Riddick::Backend::KeyValue::Value
      end
    end
  end
end
