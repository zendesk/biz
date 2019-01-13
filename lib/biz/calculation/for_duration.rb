# frozen_string_literal: true

module Biz
  module Calculation
    class ForDuration

      UNITS = %i[second seconds minute minutes hour hours day days].freeze

      private_constant :UNITS

      def self.units
        UNITS
      end

      def self.with_unit(schedule, scalar, unit)
        fail ArgumentError, 'unsupported unit' unless UNITS.include?(unit)

        public_send(unit, schedule, scalar)
      end

      def self.unit
        name.split('::').last.downcase.to_sym
      end

      def self.time_class
        Class.new(self) do
          def before(time)
            advanced_periods(:before, time).last.start_time
          end

          def after(time)
            advanced_periods(:after, time).last.end_time
          end

          private

          def advanced_periods(direction, time)
            schedule
              .periods
              .public_send(direction, time)
              .timeline
              .for(Duration.public_send(unit, scalar))
              .to_a
          end
        end
      end

      def self.day_class
        Class.new(self) do
          def before(time)
            periods(:before, time).first.end_time
          end

          def after(time)
            periods(:after, time).first.start_time
          end

          private

          def periods(direction, time)
            schedule
              .periods
              .public_send(
                direction,
                advanced_time(direction, schedule.in_zone.local(time))
              )
          end

          def advanced_time(direction, time)
            schedule
              .in_zone
              .on_date(
                schedule
                  .dates
                  .days(scalar)
                  .public_send(direction, time.to_date),
                DayTime.from_time(time)
              )
          end
        end
      end

      private_class_method :time_class,
                           :day_class

      def initialize(schedule, scalar)
        @schedule = schedule
        @scalar   = Integer(scalar)

        fail ArgumentError, 'negative scalar' if @scalar.negative?
      end

      private

      attr_reader :schedule,
                  :scalar

      def unit
        self.class.unit
      end

      [
        *%i[second seconds minute minutes hour hours].map { |unit|
          const_set(unit.to_s.capitalize, time_class)
        },
        *%i[day days].map { |unit| const_set(unit.to_s.capitalize, day_class) }
      ].each do |unit_class|
        define_singleton_method(unit_class.unit) { |schedule, scalar|
          unit_class.new(schedule, scalar)
        }
      end

    end
  end
end
