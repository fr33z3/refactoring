require 'spec_helper'

RSpec.describe CSVFileManager do
  let(:file_path) { "dummy_file_path.txt" }
  let(:default_options) { described_class::DEFAULT_CSV_OPTIONS }
  let(:manager) { described_class.new }
  let(:rows) { [double('Row1'), double('Row2')] }
  let(:headers) { ['Header1', 'Header2'] }
  let(:csv) { spy('CSV') }

  describe '#read' do
    subject { manager.read(file_path) }

    it 'reads file' do
      expect(CSV).to receive(:read).with(file_path, default_options)
      subject
    end
  end

  describe '#lazy_read' do
    subject { manager.lazy_read(file_path) }

    before do
      allow(CSV).to receive(:foreach)
        .with(file_path, default_options)
        .and_yield(rows[0]).and_yield(rows[1])
    end

    it { is_expected.to be_instance_of(Enumerator) }
    it { is_expected.to return_elements(*rows) }
  end
end
