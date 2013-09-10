require 'tspec/example'
require 'tspec/callback'

module TSpec
  describe Example do
    let(:description) { double('Description',
                               attributes: [],
                               before_callbacks: [Callback.new { @foo = 1 }],
                               after_callbacks: [Callback.new { @bar = 2 }]) }
    let(:example) { Example.new('foo', description) { @title = 'bar' } }

    it 'has a title' do
      expect(example.title).to eq 'foo'
    end

    it 'declares expectations' do
      expectation = example.expect(:foo)
      expect(expectation).to be_a Expectation
    end

    it 'runs before- and after- callbacks' do
      expect(example.instance_variable_get(:@foo)).to be nil
      expect(example.instance_variable_get(:@bar)).to be nil
      example.call
      expect(example.instance_variable_get(:@foo)).to eq 1
      expect(example.instance_variable_get(:@bar)).to eq 2
    end

    it 'forwards all unknown messages to the description' do
      description.stub(foo: 'bar')
      expect(example.foo).to eq 'bar'
    end

    describe 'test doubles' do
      it 'can spawn test doubles' do
        expect(double).to be_a TestDouble
      end

      it 'can spawn test doubles with names and stubbed methods' do
        dbl = double('foo', bar: 'baz')
        expect(dbl.name).to eq 'foo'
        expect(dbl.bar).to eq 'baz'
      end
    end

    it 'executes its block' do
      example.call
      expect(example.title).to eq 'bar'
    end

    it 'defines attributes on itself' do
      attribute = double('Attribute', bind: 'lol')
      example = Example.new('Example', double('Description'))
      example.define_attributes [attribute]
    end

    describe 'matchers' do
      it 'defines a matcher that checks type' do
        matcher = example.be_a(String)
        expect(matcher).to be_a Matcher
        expect(matcher.name).to eq 'be an object of class String'
      end

      it 'defines a matcher that checks identity' do
        matcher = example.be(:foo)
        expect(matcher).to be_a Matcher
        expect(matcher.name).to eq 'be the same object as :foo'
      end

      it 'defines a matcher that checks for exceptions' do
        matcher = example.raise_error NoMethodError
        expect(matcher).to be_a Matcher
        expect(matcher.name).to eq 'raise error NoMethodError'
      end

      it 'defines a matcher that checks equality' do
        matcher = example.eq 1
        expect(matcher).to be_a Matcher
        expect(matcher.name).to eq 'equal 1'
      end
    end
  end
end
