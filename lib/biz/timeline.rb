require 'biz/timeline/abstract'
require 'biz/timeline/forward'
require 'biz/timeline/backward'

module Biz
  class Timeline

    attr_reader :periods

    def initialize(periods)
      @periods = periods
    end

    def forward
      Forward.new(periods)
    end

    def backward
      Backward.new(periods)
    end

  end
end
