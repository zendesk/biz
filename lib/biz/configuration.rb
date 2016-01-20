module Biz
  class Configuration

    include Memoizable

    def initialize
      @raw = Raw.new.tap do |raw| yield raw if block_given? end

      Validation.perform(raw)
    end

    def intervals
      raw.hours.flat_map { |weekday, hours|
        weekday_intervals(weekday, hours)
      }.sort_by(&:start_time)
    end

    def holidays
      raw.holidays.map { |date| Holiday.new(date, time_zone) }
    end

    def time_zone
      TZInfo::TimezoneProxy.new(raw.time_zone)
    end

    def weekdays
      raw.hours.keys.to_set
    end

    protected

    attr_reader :raw

    private

    def weekday_intervals(weekday, hours)
      hours.map { |start_timestamp, end_timestamp|
        Interval.new(
          WeekTime.start(
            DayOfWeek.from_symbol(weekday).start_minute +
              DayTime.from_timestamp(start_timestamp).day_minute
          ),
          WeekTime.end(
            DayOfWeek.from_symbol(weekday).start_minute +
              DayTime.from_timestamp(end_timestamp).day_minute
          ),
          time_zone
        )
      }
    end

    memoize :intervals,
            :holidays,
            :weekdays

    Raw = Struct.new(:hours, :holidays, :time_zone) do
      module Default
        HOURS = {
          mon: {'09:00' => '17:00'},
          tue: {'09:00' => '17:00'},
          wed: {'09:00' => '17:00'},
          thu: {'09:00' => '17:00'},
          fri: {'09:00' => '17:00'}
        }.freeze

        HOLIDAYS  = [].freeze
        TIME_ZONE = 'Etc/UTC'.freeze
      end

      def initialize(*)
        super

        self.hours     ||= Default::HOURS
        self.holidays  ||= Default::HOLIDAYS
        self.time_zone ||= Default::TIME_ZONE
      end

      alias_method :business_hours=, :hours=
    end

  end
end
