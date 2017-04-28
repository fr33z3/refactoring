# input:
# - two enumerators returning elements sorted by their key
# - block calculating the key for each element
# - block combining two elements having the same key or a single element, if there is no partner
# output:
# - enumerator for the combined elements
class Combiner
  def initialize(&extractor)
    @extractor = extractor
  end

  def combine(*enumerators)
    @enumerators = enumerators

    Enumerator.new do |yielder|
      while values.any?
        yielder.yield iteration_values
        iteration_values.each_with_index do |value, index|
          enumerators[index].next if value
        end
      end
    end
  end

  private

  attr_reader :extractor, :enumerators

  def values
    enumerators.map do |enum|
      begin
        enum.peek
      rescue StopIteration
        nil
      end
    end
  end

  def iteration_values
    min_value = values.compact.min do |a, b|
    	extractor.call(a) <=> extractor.call(b)
    end
    values.map {|value| value == min_value ? value : nil}
  end
end
