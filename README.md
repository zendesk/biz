# Biz

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

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/biz/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
