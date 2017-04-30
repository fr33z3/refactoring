class Merger
  include Enumerable

  def initialize(modifiers, combiner)
    @modifiers = modifiers
    @combiner = combiner
  end

  def each
    combiner.each do |hash|
      merged = combine_hashes(hash)
      yield combine_values(merged)
    end
  end

  private

  attr_reader :modifiers, :combiner

  def combine_values(hash)
    modifiers.inject(hash) do |res, modifier|
      modifier.modify(res)
    end
  end

  def combine_hashes(list_of_rows)
    list_of_rows.each_with_object({}) do |row, res|
      unless row.nil?
        row.each do |key, value|
          (res[key] ||= []) << value
        end
      end
    end
  end
end
