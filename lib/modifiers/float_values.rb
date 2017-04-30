module Modifiers
  class FloatValues < Base
    def modification_rule(values)
      values[0].from_german_to_f.to_german_s
    end
  end
end
