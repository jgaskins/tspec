describe 'describing a feature' do
  let(:foo) { 'foo' }
  let(:bar) { 'bar' }
  let(:foobar) { "#{foo} #{bar}" }

  it 'passes when all expectations are met' do
    expect(1).to eq 1
    expect{}.not_to raise_error
  end

  it 'fails when the expectation is not met' do
    expect { expect(1).to eq 2 }.to raise_error TSpec::ExpectationNotMet
    expect {raise NoMethodError}.to raise_error NoMethodError
  end

  it 'can specify negative expectations' do
    expect { expect(1).not_to eq 1 }.to raise_error TSpec::ExpectationNotMet
    expect(1).not_to eq 2
  end

  it 'can specify that an object is of a certain class' do
    expect(1).to be_a Fixnum
    expect { expect(1).to be_a String }.to raise_error TSpec::ExpectationNotMet
  end

  it 'allows memoized data' do
    expect(foobar).to eq 'foo bar'
  end

  it 'describes a feature' do
    expect(self.description.title).to eq 'describing a feature'
  end

  describe 'when nested' do
    it 'describes a nested feature' do
      expect(self.description.title).to eq 'describing a feature when nested'
    end
  end

  context 'when nested' do
    it 'provides context blocks' do
      expect(self.description.title).to eq 'describing a feature when nested'
    end

    it 'allows examples to use let blocks provided in parent description' do
      expect(foo).to eq 'foo'
    end
  end

  describe 'alternatives to let' do
    before { @ivar = 2 }

    it 'keeps ivars declared in before blocks' do
      expect(@ivar).to eq 2 
    end

    it 'can use methods defined in the describe block' do
      expect(add_bar(name)).to eq 'Jamiebar'
    end

    def add_bar name
      name + 'bar'
    end

    def name
      'Jamie'
    end
  end
end
