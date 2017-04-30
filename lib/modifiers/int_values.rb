module Modifiers
  class IntValues < Base
    private

    def modification_rule(values)
      values[0].to_s
    end
  end
end
