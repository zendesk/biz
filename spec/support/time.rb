# frozen_string_literal: true

module Biz
  module Spec
    module Support
      module Time
        def in_zone(zone)
          TZInfo::Timezone.get(zone).local_to_utc(yield)
        end

        def week_minute(args = {})
          (args.fetch(:wday) * Biz::Time.day_minutes) + day_minute(args)
        end

        def day_minute(args = {})
          (args.fetch(:hour) * Biz::Time.hour_minutes) + args.fetch(:min, 0)
        end

        def day_second(args = {})
          (day_minute(args) * Biz::Time.minute_seconds) + args.fetch(:sec, 0)
        end

        def in_seconds(args = {})
          (args.fetch(:days, 0) * Biz::Time.day_seconds) +
            (args.fetch(:hours, 0) * Biz::Time.hour_seconds) +
            (args.fetch(:minutes, 0) * Biz::Time.minute_seconds) +
            args.fetch(:seconds, 0)
        end

        def schedule(args = {})
          Biz::Schedule.new do |config|
            config.hours = args.fetch(
              :hours,
              mon: {'09:00' => '17:00'},
              tue: {'10:00' => '16:00'},
              wed: {'09:00' => '17:00'},
              thu: {'10:00' => '16:00'},
              fri: {'09:00' => '17:00'},
              sat: {'11:00' => '14:30'}
            )

            config.shifts    = args.fetch(:shifts, {})
            config.breaks    = args.fetch(:breaks, {})
            config.holidays  = args.fetch(:holidays, [])
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
end

RSpec.configure do |c| c.include Biz::Spec::Support::Time end
