module Biz
  class DayTime

    module Timestamp
      FORMAT  = '%02d:%02d'
      PATTERN = /\A(?<hour>\d{2}):(?<minute>\d{2})(:?(?<second>\d{2}))?\Z/
    end

    include Comparable

    extend Forwardable

    class << self

      def from_time(time)
        new(time.hour * Time::HOUR + time.min * Time::MINUTE + time.sec)
      end

      def from_minute(minute)
        new(minute * Time::MINUTE)
      end

      def from_hour(hour)
        new(hour * Time::HOUR)
      end

      def from_timestamp(timestamp)
        timestamp.match(Timestamp::PATTERN) { |match|
          new(
            match[:hour].to_i * Time::HOUR +
              match[:minute].to_i * Time::MINUTE +
              match[:second].to_i
          )
        }
      end

      def midnight
        MIDNIGHT
      end

      alias_method :am, :midnight

      def noon
        NOON
      end

      alias_method :pm, :noon

      def endnight
        ENDNIGHT
      end

    end

    attr_reader :day_second

    delegate strftime: :day_time

    delegate %i[
      to_i
      to_int
    ] => :day_second

    def initialize(day_second)
      @day_second = Integer(day_second)
    end

    def hour
      day_second / Time::HOUR
    end

    def minute
      day_second % Time::HOUR / Time::MINUTE
    end

    def second
      day_second % Time::MINUTE
    end

    def day_minute
      hour * Time::MINUTES_IN_HOUR + minute
    end

    def for_dst
      self.class.new(
        (day_second + Time::HOUR) % Time::DAY
      )
    end

    def timestamp
      format(Timestamp::FORMAT, hour, minute)
    end

    def coerce(other)
      [self.class.new(other), self]
    end

    protected

    def <=>(other)
      return nil unless other.respond_to?(:to_i)

      day_second <=> other.to_i
    end

    private

    def day_time
      ::Time.new(
        Date::EPOCH.year,
        Date::EPOCH.month,
        Date::EPOCH.mday,
        hour,
        minute,
        second
      )
    end

    MIDNIGHT = from_hour(0)
    NOON     = from_hour(12)
    ENDNIGHT = from_hour(24)

  end
end
