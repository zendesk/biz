module Biz
  class Duration

    UNITS = Set.new(%i[second seconds minute minutes hour hours])

    include Equalizer.new(:seconds)
    include Comparable

    extend Forwardable

    class << self

      def with_unit(scalar, unit)
        unless UNITS.include?(unit)
          fail ArgumentError, 'The unit is not supported.'
        end

        public_send(unit, scalar)
      end

      def seconds(seconds)
        new(seconds)
      end

      alias_method :second, :seconds

      def minutes(minutes)
        new(minutes * Time::MINUTE)
      end

      alias_method :minute, :minutes

      def hours(hours)
        new(hours * Time::HOUR)
      end

      alias_method :hour, :hours

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
