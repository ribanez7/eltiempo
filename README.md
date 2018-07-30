# Eltiempo

Explanation of the architecture:

There are 3 main blocks of code semantically different:

1. The options object
2. The calculations object
3. The http_client object

The library is conceived in order to be able to scale, and that's the reason I decided to model the options object using the method chaining concepts:
All the configuration options are chainable, so the developer can choose if it want's to pass all the options in a hash, or chaining methods.

```ruby
Eltiempo::Reporter.start(Date.today).municipality('Terrassa').av_max
Eltiempo::Reporter.new(start: Date.today, municipality: 'Terrassa', operation: :max)
```

Both calls are equivalent. This is possible thanks to the chainable module, which connects the options object with the reporter. I have placed also an observer into the options, so when all the needed information is provided, it automatically executes the program. This is just for this use (command line). If this library is intended to be integrated on a different program, then it makes no sense to use the observer.

Regarding the http_client, I have included the http.rb gem, since it also shares the concepts of method chaining, and it's quite performant compared with the native ruby solution and other gems. Please note that a refinement for the String class is used here, to extract params from a url query string.

And last, the calculations object. Here there's also a refinement of the Array class to get the average from a numeric array. I have decided not to use the json version of the api.tiempo.com API, since the OX gem, used here to process xml data, is also quite performant.

There's also a utils module for the easy of time calculations. I have to say that the purpose of that is just to be able to scale this cli playing with more complex dates. That's also the reason I have included active_support parts regarding time calculations, since it has a very handy abstraction of date and time objects. But for the moment, it is not needed.

Before checking the api client, I thought that week predictions should take from monday to sunday of the current week. That's why I focused on how to deal with the proper dates, using active_support date utils and passing start and until dates. After that, I realised that the api we are using doesn't allow this kind of operations, and that for the week predictions you have to think on today plus 7 days. So from commit 0e961dc, anything has been reduced to the only possible actions we get from tiempo.com. For the same reason, I have enabled the options start, until, and between, just in case an enhancement is needed.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eltiempo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eltiempo

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/eltiempo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Eltiempo project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/eltiempo/blob/master/CODE_OF_CONDUCT.md).
