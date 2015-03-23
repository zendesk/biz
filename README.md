![biz](http://d26a57ydsghvgx.cloudfront.net/www/public/assets/images/bizlogo.png)

[![Gem Version](https://badge.fury.io/rb/biz.svg)](http://badge.fury.io/rb/biz)
[![Build Status](https://travis-ci.org/zendesk/biz.svg?branch=master)](https://travis-ci.org/zendesk/biz)
[![Code Climate](https://codeclimate.com/github/zendesk/biz/badges/gpa.svg)](https://codeclimate.com/github/zendesk/biz)
[![Test Coverage](https://codeclimate.com/github/zendesk/biz/badges/coverage.svg)](https://codeclimate.com/github/zendesk/biz)
[![Dependency Status](https://gemnasium.com/zendesk/biz.svg)](https://gemnasium.com/zendesk/biz)

Time calculations using business hours.

## Features

* Support for:
  - Intervals spanning the entire day.
  - Interday intervals and holidays.
  - Multiple intervals per day.
  - Multiple schedule configurations.
* Second-level precision on all calculations.
* Accurate handling of Daylight Saving Time.
* Thread-safe.

## Anti-Features

* No dependency on ActiveSupport.
* No monkey patching by default.

## Installation

Add this line to your application's Gemfile:

    gem 'biz'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install biz

## Configuration

```ruby
Biz.configure do |config|
  config.hours = {
    mon: {'09:00' => '17:00'},
    tue: {'00:00' => '24:00'},
    wed: {'09:00' => '17:00'},
    thu: {'09:00' => '12:00', '13:00' => '17:00'},
    sat: {'10:00' => '14:00'}
  }

  config.holidays = [Date.new(2014, 1, 1), Date.new(2014, 12, 25)]

  config.time_zone = 'America/Los_Angeles'
end
```

If global configuration isn't your thing, configure an instance instead:

```ruby
Biz::Schedule.new do |config|
  # ...
end
```

Note that times must be specified in 24-hour clock format and time zones
must be [IANA identifiers](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

## Usage

```ruby
# Find the time an amount of business time *before* a specified starting time
Biz.time(30, :minutes).before(Time.utc(2015, 1, 1, 11, 45))

# Find the time an amount of business time *after* a specified starting time
Biz.time(2, :hours).after(Time.utc(2015, 12, 25, 9, 30))

# Calculations can be performed in seconds, minutes, hours, or days
Biz.time(1, :day).after(Time.utc(2015, 1, 8, 10))

# Find the amount of business time between two times
Biz.within(Time.utc(2015, 3, 7), Time.utc(2015, 3, 14)).in_seconds

# Determine if a time is in business hours
Biz.in_hours?(Time.utc(2015, 1, 10, 9))
```

Note that all returned times are in UTC.

By dropping down a level, you can get access to the underlying time segments,
which you can use to do your own custom calculations or just get a better idea
of what's happening under the hood:

```ruby
Biz.periods.after(Time.utc(2015, 1, 10, 10)).timeline
  .until(Time.utc(2015, 1, 17, 10)).to_a

#=> [#<Biz::TimeSegment start_time=2015-01-10 18:00:00 UTC end_time=2015-01-10 22:00:00 UTC>,
#  #<Biz::TimeSegment start_time=2015-01-12 17:00:00 UTC end_time=2015-01-13 01:00:00 UTC>,
#  #<Biz::TimeSegment start_time=2015-01-13 08:00:00 UTC end_time=2015-01-14 08:00:00 UTC>,
#  #<Biz::TimeSegment start_time=2015-01-14 17:00:00 UTC end_time=2015-01-15 01:00:00 UTC>,
#  #<Biz::TimeSegment start_time=2015-01-15 17:00:00 UTC end_time=2015-01-15 20:00:00 UTC>,
#  #<Biz::TimeSegment start_time=2015-01-15 21:00:00 UTC end_time=2015-01-16 01:00:00 UTC>]

Biz.periods
  .before(Time.utc(2015, 5, 5, 12, 34, 57)).timeline
  .for(Biz::Duration.minutes(3_598)).to_a

#=> [#<Biz::TimeSegment start_time=2015-05-05 07:00:00 UTC end_time=2015-05-05 12:34:57 UTC>,
#  #<Biz::TimeSegment start_time=2015-05-04 16:00:00 UTC end_time=2015-05-05 00:00:00 UTC>,
#  #<Biz::TimeSegment start_time=2015-05-02 17:00:00 UTC end_time=2015-05-02 21:00:00 UTC>,
#  #<Biz::TimeSegment start_time=2015-04-30 20:00:00 UTC end_time=2015-05-01 00:00:00 UTC>,
#  #<Biz::TimeSegment start_time=2015-04-30 16:00:00 UTC end_time=2015-04-30 19:00:00 UTC>,
#  #<Biz::TimeSegment start_time=2015-04-29 16:00:00 UTC end_time=2015-04-30 00:00:00 UTC>,
#  #<Biz::TimeSegment start_time=2015-04-28 07:00:00 UTC end_time=2015-04-29 07:00:00 UTC>,
#  #<Biz::TimeSegment start_time=2015-04-27 20:36:57 UTC end_time=2015-04-28 00:00:00 UTC>]
```

## Core Extensions

Optional extensions to core classes (`Date`, `Fixnum`, and `Time`) are available
for additional expressiveness:

```ruby
require 'biz/core_ext'

75.business_seconds.after(Time.utc(2015, 3, 5, 12, 30))

30.business_minutes.before(Time.utc(2015, 1, 1, 11, 45))

5.business_hours.after(Time.utc(2015, 4, 7, 8, 20))

3.business_days.before(Time.utc(2015, 5, 9, 4, 12))

Time.utc(2015, 8, 20, 9, 30).business_hours?

Date.new(2015, 12, 10).business_day?
```

## Contributing

Pull requests are welcome, but consider asking for a feature or bug fix first
through the issue tracker. When contributing code, please squash sloppy commits
aggressively and follow [Tim Pope's guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
for commit messages.

There are a number of ways to get started after cloning the repository.

To set up your environment:

    script/bootstrap

To run the spec suite:

    script/spec

To open a console with the gem and sample schedule loaded:

    script/console

## Alternatives

* [`business_time`](https://github.com/bokmann/business_time)
* [`working_hours`](https://github.com/Intrepidd/working_hours)

## Copyright and license

Copyright 2015 Zendesk

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this gem except in compliance with the License.

You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
