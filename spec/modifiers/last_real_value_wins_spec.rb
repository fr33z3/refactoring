require 'spec_helper'

RSpec.describe Modifiers::LastRealValueWins do
  let(:data) { { 'Key 1' => [1, nil, 2, '', '0', 3, 0], 'Key 2' => [5, 3] } }
  let(:modified_data) { { 'Key 1' => 3, 'Key 2' => [5, 3] } }
  let(:modifier) { described_class.new(['Key 1']) }
  subject { modifier.modify(data) }

  it { is_expected.to eq modified_data }
end
