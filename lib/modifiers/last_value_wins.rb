module Modifiers
  class LastValueWins < Base
    private

    def modification_rule(values)
      values.last
    end
  end
end
