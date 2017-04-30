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
        yielder.yield iteration_values!
      end
    end
  end

  private

  attr_reader :extractor, :enumerators

  def get_value(enumerator)
    enumerator.peek
  rescue StopIteration
    nil
  end

  def values
    enumerators.map{|enum| get_value(enum)}
  end

  def min_value
    values.compact.min do |a, b|
      extractor.call(a) <=> extractor.call(b)
    end
  end

  def iteration_values!
    min = min_value
    enumerators.map do |enum|
      value = get_value(enum)
      if value == min
        enum.next
        value
      end
    end
  end
end
