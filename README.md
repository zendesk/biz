# Biz
[![Build Status](https://magnum.travis-ci.com/zendesk/biz.svg?token=FPvAz1WHPkjgRp2szEGq&branch=master)](https://magnum.travis-ci.com/zendesk/biz)
[![Code Climate](https://codeclimate.com/repos/54ac74216956802dc40027d6/badges/591180c7fa5da2a8aa3d/gpa.svg)](https://codeclimate.com/repos/54ac74216956802dc40027d6/feed)
[![Test Coverage](https://codeclimate.com/repos/54ac74216956802dc40027d6/badges/591180c7fa5da2a8aa3d/coverage.svg)](https://codeclimate.com/repos/54ac74216956802dc40027d6/feed)

A gem for manipulating time with business hours.

## Why?

Similar gems out there suffer from a few common problems:

* Incorrect handling of Daylight Saving Time
* Inability to provide second-level precision
* Heavy reliance on (slow) ActiveSupport time objects and extensions

This gem solves these issues by performing set operations on pure integer
representations of time segments before returning a result in the desired
form.

## Installation

Add this line to your application's Gemfile:

    gem 'biz'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install biz

## Configuration

```ruby
Biz::Schedule.new do |config|
  config.work_hours = {
    mon: {'09:00' => '12:00', '13:00' => '17:00'},
    tue: {'09:00' => '12:00', '13:00' => '17:00'},
    wed: {'09:00' => '12:00', '13:00' => '17:00'},
    thu: {'09:00' => '12:00', '13:00' => '17:00'},
    fri: {'09:00' => '12:00', '13:00' => '17:00'},
    sat: {'10:00' => '14:00'}
  }

  config.holidays = [Date.new(2014, 1, 1), Date.new(2014, 12, 25)]

  config.time_zone = 'America/Los_Angeles'
end
```

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/biz/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
