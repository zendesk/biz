module Biz
  class Week

    include Comparable

    extend Forwardable

    def self.from_date(date)
      new(Day.from_date(date).to_i / Time::DAYS_IN_WEEK)
    end

    def self.from_time(time)
      from_date(time.to_date)
    end

    class << self

      alias since_epoch from_time

    end

    attr_reader :week

    delegate %i[
      to_s
      to_i
      to_int
    ] => :week

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

      week.downto(final_week.to_i).each do |raw_week|
        yield self.class.new(raw_week)
      end
    end

    def +(other)
      self.class.new(week + other.week)
    end

    protected

    def <=>(other)
      return nil unless other.respond_to?(:to_i)

      week <=> other.to_i
    end

  end
end
