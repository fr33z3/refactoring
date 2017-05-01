# rubocop:disable LineLength
RSpec::Matchers.define :be_empty do
  match do |enumerator|
    read_from_enumerator(enumerator).empty?
  end
end

RSpec::Matchers.define :return_elements do |*expected|
  read_elements = nil

  match do |enumerator|
    read_elements = read_from_enumerator(enumerator)
    read_elements == expected
  end

  failure_message_for_should do |enumerator|
    "expected that #{enumerator} would return #{expected.inspect}, but it returned #{read_elements.inspect}"
  end
end
# rubocop:enable LineLength
