# input:
# - two enumerators returning elements sorted by their key
# - block calculating the key for each element
# - block combining two elements having the same key or a single element, if there is no partner
# output:
# - enumerator for the combined elements
class Combiner
  def initialize(&key_extractor)
    @key_extractor = key_extractor
  end

  def combine(*enumerators)
    Enumerator.new do |yielder|
      last_values = Array.new(enumerators.size)
      done = enumerators.none?
      while not done
        last_values.each_with_index do |value, index|
          if value.nil? && !enumerators[index].nil?
            begin
              last_values[index] = enumerators[index].next
            rescue StopIteration
              enumerators[index] = nil
            end
          end
        end

        done = enumerators.none? && last_values.none?
        unless done
          min_key = last_values.map { |val| key(val) }.compact.min
          values = Array.new(last_values.size)
          last_values.each_with_index do |value, index|
            if key(value) == min_key
              values[index] = value
              last_values[index] = nil
            end
          end

          yielder.yield(values)
        end
      end
    end
  end

  private

  attr_reader :key_extractor

  def key(value)
    value.nil? ? nil : @key_extractor.call(value)
  end
end
