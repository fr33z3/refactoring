module Modifiers
  class Factor < Base
    def initialize(factor, keys)
      super keys
      @factor = factor
    end

    private

    def modification_rule(values)
      (factor * values[0].from_german_to_f).to_german_s
    end

    attr_reader :factor
  end
end
