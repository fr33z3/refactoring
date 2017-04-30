module Modifiers
  class Base
    def initialize(keys)
      @keys = keys
    end

    def modify(hash)
      keys.each_with_object(hash) do |key, res|
        res[key] = modification_rule(res[key])
      end
    end

    private

    attr_reader :keys
  end
end
