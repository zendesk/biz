module Biz
  class Timeline

    def initialize(periods)
      @periods = periods
    end

    def forward
      Forward.new(periods)
    end

    def backward
      Backward.new(periods)
    end

    protected

    attr_reader :periods

  end
end

require 'biz/timeline/abstract'

require 'biz/timeline/forward'
require 'biz/timeline/backward'
