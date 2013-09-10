require 'tspec/test_double'

module TSpec
  describe TestDouble do
    let(:dbl) { TestDouble.new('Name goes here', id: 1) }

    it 'has the specified name' do
      expect(dbl.name).to eq 'Name goes here'
    end

    it 'has specified stubbed methods' do
      expect(dbl.id).to eq 1
    end

    it 'is equal to another test dbl with equal name and methods' do
      expect(dbl.dup).to eq dbl
    end

    it 'raises an UnexpectedMessageError when sent a message it does not know' do
      expect {
        dbl.not_a_method
      }.to raise_error TestDouble::UnexpectedMessageError
    end

    it 'can fake its own class' do
      double = TestDouble.new('Fake String', class: String)
      expect(double.class).to eq String
    end

    it 'can be a blank test double' do
      double = TestDouble.new
      expect(double.name).to eq nil
    end

    it 'has a specific inspect format' do
      double = TestDouble.new('foo', bar: 'baz')
      expected_string = %Q(#<TSpec::TestDouble:0x#{double.object_id.to_s(16)} @name="foo" bar="baz">)
      expect(double.inspect).to eq expected_string
    end

    it 'can receive arguments with its messages' do
      double = TestDouble.new('foo', bar: 'baz')
      expect(double.bar('lol')).to eq 'baz'
    end

    it 'can stub additional methods' do
      double = TestDouble.new('foo', bar: 'baz')
      double.stub(quux: 1)
      expect(double.quux).to eq 1
    end
  end
end
