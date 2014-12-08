require 'biz/periods/abstract'
require 'biz/periods/after'
require 'biz/periods/before'

module Biz
  class Periods

    attr_reader :schedule

    def initialize(schedule)
      @schedule = schedule
    end

    def after(origin)
      After.new(schedule, origin)
    end

    def before(origin)
      Before.new(schedule, origin)
    end

  end
end
