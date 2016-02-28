module Biz
  module Calculation
    class ForDuration

      UNITS = %i[second seconds minute minutes hour hours day days].freeze

      def self.with_unit(schedule, scalar, unit)
        unless UNITS.include?(unit)
          fail ArgumentError, 'The unit is not supported.'
        end

        send(unit, schedule, scalar)
      end

      def self.unit
        name.split('::').last.downcase.to_sym
      end

      def initialize(schedule, scalar)
        @schedule = schedule
        @scalar   = scalar
      end

      protected

      attr_reader :schedule,
                  :scalar

      private

      def unit
        self.class.unit
      end

      [
        *%i[second seconds minute minutes hour hours].map { |unit|
          const_set(
            unit.to_s.capitalize,
            Class.new(self) do
              def before(time)
                timeline(:before, time).last.start_time
              end

              def after(time)
                timeline(:after, time).last.end_time
              end

              private

              def timeline(direction, time)
                schedule.periods.send(direction, time).timeline
                  .for(duration).to_a
              end

              def duration
                Duration.send(unit, scalar)
              end
            end
          )
        },
        *%i[day days].map { |unit|
          const_set(
            unit.to_s.capitalize,
            Class.new(self) do
              def before(time)
                periods(:before, time).first.end_time
              end

              def after(time)
                periods(:after, time).first.start_time
              end

              private

              def periods(direction, time)
                schedule.periods.send(direction, advanced_date(direction, time))
              end

              def advanced_date(direction, time)
                schedule.in_zone.on_date(
                  schedule.dates.days(scalar).send(direction, local(time)),
                  day_time(time)
                )
              end

              def day_time(time)
                DayTime.from_time(local(time))
              end

              def local(time)
                schedule.in_zone.local(time)
              end
            end
          )
        }
      ].each do |unit_class|
        define_singleton_method(unit_class.unit) { |schedule, scalar|
          unit_class.new(schedule, scalar)
        }
      end

    end
  end
end
