module Biz
  module SpecSupport
    module Time

      def in_zone(zone)
        TZInfo::Timezone.get(zone).local_to_utc(yield)
      end

      def raw_interval(args = {})
        args.merge(
          start_time: week_minute(args.fetch(:start_time)),
          end_time:   week_minute(args.fetch(:end_time))
        )
      end

      def raw_holiday(args = {})
        if args.is_a?(Hash)
          start_date = args.fetch(:start_date) { args.delete(:date) }
          end_date   = args.fetch(:end_date) { start_date }
          name       = args.fetch(:name, 'Test Holiday')
          raw_args   = args
        else
          start_date = args
          end_date   = args
          name       = 'Test Holiday'
          raw_args   = {}
        end

        raw_args.merge(
          name:       name,
          start_date: Day.since_epoch(start_date),
          end_date:   Day.since_epoch(end_date)
        )
      end

      def week_minute(args = {})
        args.fetch(:wday) * Biz::Time::MINUTES_IN_DAY + day_minute(args)
      end

      def day_minute(args = {})
        args.fetch(:hour) * Biz::Time::MINUTES_IN_HOUR + args.fetch(:min, 0)
      end

      def day_since_epoch(args = {})
        args.fetch(:week) * Biz::Time::DAYS_IN_WEEK + args.fetch(:wday)
      end

      def in_seconds(args = {})
        args.fetch(:days, 0) * Biz::Time::DAY +
          args.fetch(:hours, 0) * Biz::Time::HOUR +
          args.fetch(:minutes, 0) * Biz::Time::MINUTE +
          args.fetch(:seconds, 0)
      end

      def schedule(args = {})
        Biz::Schedule.new do |config|
          config.work_hours = args.fetch(:work_hours,
            mon: {'09:00' => '17:00'},
            tue: {'10:00' => '16:00'},
            wed: {'09:00' => '17:00'},
            thu: {'10:00' => '16:00'},
            fri: {'09:00' => '17:00'},
            sat: {'11:00' => '14:30'}
          )

          config.holidays = args.fetch(:holidays, [])

          config.time_zone = args.fetch(:time_zone, 'Etc/UTC')
        end
      end

      def forward_periods
        Enumerator.new do |yielder|
          (2006..Float::INFINITY).each do |year|
            yielder.yield(
              Biz::TimeSegment.new(::Time.utc(year), ::Time.utc(year, 2))
            )
          end
        end
      end

      def backward_periods
        Enumerator.new do |yielder|
          2006.downto(-Float::INFINITY).each do |year|
            yielder.yield(
              Biz::TimeSegment.new(::Time.utc(year), ::Time.utc(year, 2))
            )
          end
        end
      end

    end
  end
end

RSpec.configure do |c| c.include Biz::SpecSupport::Time end
