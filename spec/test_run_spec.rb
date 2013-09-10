require 'tspec/test_run'
require 'stringio'

module TSpec
  describe TestRun do
    let(:fake_tspec) { double('FakeTSpec', descriptions: []) }
    let(:test_run) { TestRun.new(tspec: fake_tspec, output: StringIO.new) }

    it 'has examples' do
      expect(test_run.examples).to be_a Array
      expect(test_run.examples.count).to be 0
    end

    it 'runs an example' do
      example = -> { @foo = 'bar' }
      test_run.run_example example
      expect(@foo).to eq 'bar'
    end

    it 'runs a failed example' do
      example = -> { raise }
      test_run.run_example example
      expect(test_run.failures.count).to eq 1
    end

    it 'checks its runtime in milliseconds' do
      # Set known start and end times in seconds
      test_run.define_singleton_method(:start) { 1.001 }
      test_run.define_singleton_method(:finish) { 11.010 }
      expect(test_run.runtime).to eq 10_009
    end
  end
end
