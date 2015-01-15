module Biz
  class DayTime

    TIMESTAMP_FORMAT  = '%02d:%02d'
    TIMESTAMP_PATTERN = /(?<hour>\d{2}):(?<minute>\d{2})/

    include Comparable

    extend Forwardable

    def self.from_hour(hour)
      new(hour * Time::MINUTES_IN_HOUR)
    end

    def self.from_timestamp(timestamp)
      timestamp.match(TIMESTAMP_PATTERN) { |match|
        new(match[:hour].to_i * Time::MINUTES_IN_HOUR + match[:minute].to_i)
      }
    end

    def self.midnight
      MIDNIGHT
    end

    def self.noon
      NOON
    end

    def self.endnight
      ENDNIGHT
    end

    class << self

      alias_method :am, :midnight

      alias_method :pm, :noon

    end

    attr_reader :day_minute

    delegate strftime: :day_time

    delegate %i[
      to_i
      to_int
    ] => :day_minute

    def initialize(day_minute)
      @day_minute = Integer(day_minute)
    end

    def hour
      day_minute / Time::MINUTES_IN_HOUR
    end

    def minute
      day_minute % Time::MINUTES_IN_HOUR
    end

    def timestamp
      format(TIMESTAMP_FORMAT, hour, minute)
    end

    def coerce(other)
      [self.class.new(other), self]
    end

    protected

    def <=>(other)
      return nil unless other.respond_to?(:to_i)

      day_minute <=> other.to_i
    end

    private

    def day_time
      ::Time.new(
        Date::EPOCH.year,
        Date::EPOCH.month,
        Date::EPOCH.mday,
        hour,
        minute
      )
    end

    MIDNIGHT = from_hour(0)
    NOON     = from_hour(12)
    ENDNIGHT = from_hour(24)

  end
end
