# TSpec

Lightweight spec framework inspired by RSpec (because, really, what isn't inspired by RSpec these days?). Syntax intends to be compatible with RSpec's `expect` syntax. For example:

```ruby
describe Foo do
  let(:foo) { Foo.new }

  it 'does a thing' do
    expect(foo.bar).to eq 'baz'
  end
end
```

Matchers currently available:

- `eq` (equality using `==` operator): `expect(foo.bar).to eq 'baz'`
- `raise_error` (given block is expected to raise the specified exception): `expect { foo.bar }.to raise_error Baz`
- `be_a` (given object is expected to be an instance of the given class or one of its subclasses): `expect(foo).to be_a Foo`
- `be` (equality compared using `Object.equal?`): `expect(foo).to be foo`

TSpec is intended to be able to run your specs in parallel.

## Installation

Add this line to your application's Gemfile:

    gem 'tspec'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tspec

## Usage

To run an individual spec file:

    $ tspec spec/path/to/spec.rb

You can run all spec files within a directory:

    $ tspec spec/unit # will load spec/unit/**/*_spec.rb

Run with no arguments to run all specs in the `./spec` directory:

    $ tspec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
