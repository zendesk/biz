require 'biz/duration'
require 'biz/time'
require 'biz/week'
require 'equalizer'

module Biz
  class TimeSegment

    include Equalizer.new(:start_time, :end_time)

    def self.before(time)
      new(Time::BIG_BANG, time)
    end

    def self.after(time)
      new(time, Time::HEAT_DEATH)
    end

    attr_reader :start_time,
                :end_time

    def initialize(start_time, end_time)
      @start_time = Integer(start_time)
      @end_time   = Integer(end_time)
    end

    def duration
      Duration.new(end_time - start_time)
    end

    def endpoints
      [start_time, end_time]
    end

    def empty?
      start_time >= end_time
    end

    def &(other)
      self.class.new(
        lower_bound(other),
        [lower_bound(other), upper_bound(other)].max
      )
    end

    def /(other)
      [
        self.class.new(start_time, other.start_time),
        self.class.new(other.end_time, end_time)
      ].reject(&:empty?).map { |potential| self & potential }
    end

    def inspect
      "#{::Time.at(start_time).utc} #{::Time.at(end_time).utc}"
    end

    private

    def lower_bound(other)
      [self, other].map(&:start_time).max
    end

    def upper_bound(other)
      [self, other].map(&:end_time).min
    end

  end
end
