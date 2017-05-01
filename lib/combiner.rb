# input:
# - two enumerators returning elements sorted by their key
# - block calculating the key for each element
# - block combining two elements having the same key or a single element, if there is no partner
# output:
# - enumerator for the combined elements

class Combiner
  include Enumerable

  def initialize(*enumerators, &extractor)
    @extractor = extractor
    @enumerators = enumerators
  end

  def each
    while values.any?
      yield iteration_values!
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
      if value && extractor.call(value) == extractor.call(min)
        enum.next
        value
      end
    end
  end
end
