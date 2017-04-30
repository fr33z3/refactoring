module Modifiers
  class LastRealValueWins < Base
    private

    def modification_rule(values)
      values.select do |value|
        value && value.to_i != 0
      end.last
    end
  end
end
