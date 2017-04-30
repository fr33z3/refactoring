require 'spec_helper'

RSpec.describe Modifiers::IntValues do
  let(:data) { { 'Key 1' => [1, 1], 'Key 2' => [5, 3] } }
  let(:modified_data) { { 'Key 1' => '1', 'Key 2' => [5, 3] } }
  let(:modifier) { described_class.new(['Key 1']) }
  subject { modifier.modify(data) }

  it { is_expected.to eq modified_data }
end
