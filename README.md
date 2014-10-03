# LazyObject

It's an object wrapper that forwards all calls to the reference target object.
This object is not created until the first method dispatch.

## Installation

Add this line to your application's Gemfile:

    gem 'lazy_object'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lazy_object

## Usage

Pass a block to the initializer, which returns an instance of the target
object. Lazy object forwards all method calls to the target. The block only
gets called the first time a method is forwarded.

Example:

```ruby
lazy = LazyObject.new { VeryExpensiveObject.new }
# At this point the VeryExpensiveObject hasn't been initialized yet.

# Initializes VeryExpensiveObject and calls 'get_expensive_results' on it, passing in foo and bar
lazy.get_expensive_results(foo, bar)

# You can pass in blocks to the target.
lazy.perform_operation do |foo, bar|
  foo + bar
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/lazy_object/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
6. Make sure all the test pass and your changes have test coverage!
