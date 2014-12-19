module Biz
  class Duration

    UNITS = Set[:seconds, :minutes, :hours, :days]

    include Equalizer.new(:seconds)
    include Comparable

    extend Forwardable

    def self.with_unit(unit, duration)
      unless UNITS.include?(unit)
        fail ArgumentError, 'The unit is not supported.'
      end

      public_send(unit, duration)
    end

    def self.seconds(seconds)
      new(seconds)
    end

    def self.minutes(minutes)
      new(minutes * Time::MINUTE)
    end

    def self.hours(hours)
      new(hours * Time::HOUR)
    end

    def self.days(days)
      new(days * Time::DAY)
    end

    attr_reader :seconds

    delegate to_i: :seconds

    def initialize(seconds)
      @seconds = Integer(seconds)
    end

    def in_seconds
      seconds
    end

    def in_minutes
      seconds / Time::MINUTE
    end

    def in_hours
      seconds / Time::HOUR
    end

    def in_days
      seconds / Time::DAY
    end

    def +(other)
      self.class.new(seconds + other.seconds)
    end

    def -(other)
      self.class.new(seconds - other.seconds)
    end

    def positive?
      seconds > 0
    end

    def abs
      self.class.new(seconds.abs)
    end

    def coerce(other)
      [self.class.new(other), self]
    end

    protected

    def <=>(other)
      return nil unless other.respond_to?(:to_i)

      seconds <=> other.to_i
    end

  end
end
