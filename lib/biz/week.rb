module Biz
  class Week

    include Comparable

    def self.from_date(date)
      new((date - Date::EPOCH).to_i / Time::DAYS_IN_WEEK)
    end

    def self.from_time(time)
      from_date(time.to_date)
    end

    class << self

      alias since_epoch from_time

    end

    attr_reader :week

    def initialize(week)
      @week = Integer(week)
    end

    def start_date
      Date.from_day(week * Time::DAYS_IN_WEEK)
    end

    def succ
      self.class.new(week.succ)
    end

    def downto(final_week)
      return enum_for(:downto, final_week) unless block_given?

      week.downto(final_week.week).each do |raw_week|
        yield self.class.new(raw_week)
      end
    end

    def +(other)
      self.class.new(week + other.week)
    end

    def <=>(other)
      return unless other.is_a?(self.class)

      week <=> other.week
    end

  end
end
