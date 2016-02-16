module Biz
  class DayTime

    VALID_SECONDS = 0..Time::SECONDS_IN_DAY

    module Timestamp
      FORMAT  = '%02d:%02d'.freeze
      PATTERN = /\A(?<hour>\d{2}):(?<minute>\d{2})(:?(?<second>\d{2}))?\Z/
    end

    include Comparable

    extend Forwardable

    class << self

      def from_time(time)
        new(
          time.hour * Time::SECONDS_IN_HOUR +
            time.min * Time::SECONDS_IN_MINUTE +
            time.sec
        )
      end

      def from_minute(minute)
        new(minute * Time::SECONDS_IN_MINUTE)
      end

      def from_hour(hour)
        new(hour * Time::SECONDS_IN_HOUR)
      end

      def from_timestamp(timestamp)
        timestamp.match(Timestamp::PATTERN) { |match|
          new(
            match[:hour].to_i * Time::SECONDS_IN_HOUR +
              match[:minute].to_i * Time::SECONDS_IN_MINUTE +
              match[:second].to_i
          )
        }
      end

      def midnight
        MIDNIGHT
      end

      alias am midnight

      def noon
        NOON
      end

      alias pm noon

      def endnight
        ENDNIGHT
      end

    end

    attr_reader :day_second

    delegate strftime: :format_time

    delegate %i[
      to_i
      to_int
    ] => :day_second

    def initialize(day_second)
      @day_second = Integer(day_second)

      unless VALID_SECONDS.cover?(@day_second)
        fail ArgumentError, 'Invalid number of seconds for a day.'
      end
    end

    def hour
      day_second / Time::SECONDS_IN_HOUR
    end

    def minute
      day_second % Time::SECONDS_IN_HOUR / Time::SECONDS_IN_MINUTE
    end

    def second
      day_second % Time::SECONDS_IN_MINUTE
    end

    def day_minute
      hour * Time::MINUTES_IN_HOUR + minute
    end

    def for_dst
      self.class.new(
        (day_second + Time::SECONDS_IN_HOUR) % Time::SECONDS_IN_DAY
      )
    end

    def timestamp
      format(Timestamp::FORMAT, hour, minute)
    end

    def <=>(other)
      return nil unless other.respond_to?(:to_i)

      day_second <=> other.to_i
    end

    private

    def format_time
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
