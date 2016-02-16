module Biz
  class Day

    include Comparable

    extend Forwardable

    def self.from_date(date)
      new((date - Date::EPOCH).to_i)
    end

    def self.from_time(time)
      from_date(time.to_date)
    end

    class << self

      alias since_epoch from_time

    end

    attr_reader :day

    delegate %i[
      to_s
      to_i
      to_int
    ] => :day

    def initialize(day)
      @day = Integer(day)
    end

    def to_date
      Date.from_day(day)
    end

    def <=>(other)
      return unless other.is_a?(self.class)

      day <=> other.day
    end

  end
end
