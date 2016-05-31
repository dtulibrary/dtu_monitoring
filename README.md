# DtuMonitoring

This gem provides common interfaces for writing to DTU Library's monitoring apparatus.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dtu_monitoring'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dtu_monitoring

## Usage

`DtuMonitoring` requires an environment variable `INFLUX_API` to be set. This should include the name of the database you wish to write to, e.g. `http://influxapi.test.dtu.dk:9999/write?db=mydb`.  

At present the only high level interface available is `DtuMonitoring::BlacklightResponse`. This is called from a Blacklight instance with three arguments, the calling application, the response hash from Blacklight, and a timestamp. It then parses the response data and forwards it to `DtuMonitoring::InfluxWriter` which writes to `InfluxDB`. To use it in your application, you can do the following:

```ruby
#  catalog_controller.rb

after_action :monitor if: ->{ @response.present? }

def monitor
    DtuMonitoring::BlacklightResponse.delay.monitor('my_app', @response, Time.now.to_i)
end
```    
This example presumes that you are using `delayed_job` in your application. It is a good idea to run monitoring in the background to prevent it from impacting on user experience.  

## Extension

It is recommended that other wrappers follow a similar pattern to `DtuMonitoring::BlacklightResponse`: i.e., implement a `self.monitor` method that will format the relevant data and pass it to `InfluxWriter`. In this way, the implementation details of our monitoring solution are hidden from the client classes.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dtulibrary/dtu_monitoring. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

