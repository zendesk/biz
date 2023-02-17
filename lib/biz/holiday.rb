# frozen_string_literal: true

module Biz
  class Holiday

    extend Forwardable

    include Comparable

    def initialize(date, time_zone)
      @date      = date
      @time_zone = time_zone
    end

    delegate contains?: :to_time_segment

    def to_time_segment
      @to_time_segment ||=
        TimeSegment.new(
          Time.new(time_zone).on_date(date, DayTime.midnight),
          Time.new(time_zone).on_date(date, DayTime.endnight)
        )
    end

    protected

    attr_reader :date,
                :time_zone

    public

    def to_date
      date
    end

    private

    def <=>(other)
      return unless other.is_a?(self.class)

      [date, time_zone] <=> [other.date, other.time_zone]
    end

  end
end
