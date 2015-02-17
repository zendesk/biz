# biz
[![Gem Version](https://badge.fury.io/rb/biz.svg)](http://badge.fury.io/rb/biz)
[![Build Status](https://travis-ci.org/zendesk/biz.svg)](https://travis-ci.org/zendesk/biz)
[![Code Climate](https://codeclimate.com/github/zendesk/biz/badges/gpa.svg)](https://codeclimate.com/github/zendesk/biz)
[![Test Coverage](https://codeclimate.com/github/zendesk/biz/badges/coverage.svg)](https://codeclimate.com/github/zendesk/biz)
[![Dependency Status](https://gemnasium.com/zendesk/biz.svg)](https://gemnasium.com/zendesk/biz)

Time calculations using business hours.

## Features

* Second-level precision on all calculations.
* Accurate handling of Daylight Saving Time.
* Support for intervals spanning any period of the day, including the entirety.
* Support for interday intervals and holidays.
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
  config.business_hours = {
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

## Usage

```ruby
# Find the time an amount of business time *before* a specified starting time
Biz.time(30, :minutes).before(Time.utc(2015, 1, 1, 11, 45))

# Find the time an amount of business time *after* a specified starting time
Biz.time(2, :hours).after(Time.utc(2015, 12, 25, 9, 30))

# Find the amount of business time between two times
Biz.within(Time.utc(2015, 3, 7), Time.utc(2015, 3, 14)).in_seconds

# Determine if a time is in business hours
Biz.business_hours?(Time.utc(2015, 1, 10, 9))
```

## Core Extensions

Optional extensions to core classes (`Date`, `Fixnum`, and `Time`) are available
for additional expressiveness:

```ruby
require 'biz/core_ext'

75.business_seconds.after(Time.utc(2015, 3, 5, 12, 30))

30.business_minutes.before(Time.utc(2015, 1, 1, 11, 45))

5.business_hours.after(Time.utc(2015, 4, 7, 8, 20))

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

## Copyright and license

Copyright 2015 Zendesk

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License.

You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
