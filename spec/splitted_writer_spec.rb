require 'spec_helper'

RSpec.describe SplittedWriter do
  let(:file1) { spy('File1') }
  let(:file2) { spy('File2') }
  let(:file_manager) { spy('File manager') }
  let(:file_name) { 'some_file.ext' }
  let(:writer) { described_class.new(file_manager, file_name, 4) }
  let(:headers) { double('Headers') }
  let(:values) { double('Values') }
  let(:row) { double('Row', keys: headers, values: values) }

  subject do
    4.times.each { writer.write(row) }
    writer.close
  end

  before do
    allow(file_manager).to receive(:open_write).with('some_file_0.ext').and_return file1
    allow(file_manager).to receive(:open_write).with('some_file_1.ext').and_return file2
    subject
  end

  it { expect(file_manager).to have_received(:open_write).with('some_file_0.ext') }
  it { expect(file_manager).to have_received(:open_write).with('some_file_1.ext') }
  it { expect(file1).to have_received(:<<).with(headers).once }
  it { expect(file1).to have_received(:<<).with(values).exactly(3).times }
  it { expect(file1).to have_received(:close).once }
  it { expect(file2).to have_received(:<<).with(headers).once }
  it { expect(file2).to have_received(:<<).with(values).once }
  it { expect(file2).to have_received(:close).once }
end
