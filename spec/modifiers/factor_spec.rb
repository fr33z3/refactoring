require 'spec_helper'

RSpec.describe Modifiers::Factor do
  let(:data) { { 'Key 1' => ['1,2', '1,2'], 'Key 2' => [5, 3] } }
  let(:factor) { 2 }
  let(:modified_data) { { 'Key 1' => '2,4', 'Key 2' => [5, 3] } }
  let(:modifier) { described_class.new(factor, ['Key 1']) }
  subject { modifier.modify(data) }

  it { is_expected.to eq modified_data }
end
