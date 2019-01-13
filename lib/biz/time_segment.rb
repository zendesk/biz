# frozen_string_literal: true

module Biz
  class TimeSegment

    include Comparable

    def self.before(time)
      new(Time.big_bang, time)
    end

    def self.after(time)
      new(time, Time.heat_death)
    end

    def initialize(start_time, end_time)
      @start_time = start_time
      @end_time   = end_time
      @date       = start_time.to_date
    end

    attr_reader :start_time,
                :end_time,
                :date

    def duration
      Duration.new([end_time - start_time, 0].max)
    end

    def endpoints
      [start_time, end_time]
    end

    def empty?
      start_time == end_time
    end

    def disjoint?
      start_time > end_time
    end

    def contains?(time)
      (start_time...end_time).cover?(time)
    end

    def &(other)
      self.class.new(
        [self, other].map(&:start_time).max,
        [self, other].map(&:end_time).min
      )
    end

    def /(other)
      [
        self.class.new(start_time, other.start_time),
        self.class.new(other.end_time, end_time)
      ].reject(&:disjoint?).map { |potential| self & potential }
    end

    private

    def <=>(other)
      return unless other.is_a?(self.class)

      [start_time, end_time] <=> [other.start_time, other.end_time]
    end

  end
end
