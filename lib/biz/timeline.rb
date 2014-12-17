require 'biz/timeline/abstract'
require 'biz/timeline/after'
require 'biz/timeline/before'

module Biz
  class Timeline

    attr_reader :periods

    def initialize(periods)
      @periods = periods
    end

    def after(origin)
      After.new(periods, origin)
    end

    def before(origin)
      Before.new(periods, origin)
    end

  end
end
