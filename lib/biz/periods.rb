require 'biz/periods/after'
require 'biz/periods/before'

module Biz
  class Periods

    attr_reader :schedule

    def initialize(schedule)
      @schedule = schedule
    end

    def after(origin)
      After.new(origin, schedule)
    end

    def before(origin)
      Before.new(origin, schedule)
    end

  end
end
