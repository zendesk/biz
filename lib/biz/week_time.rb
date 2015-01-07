module Biz
  module WeekTime
    class << self

      def start(week_minute)
        Start.new(week_minute)
      end

      def end(week_minute)
        End.new(week_minute)
      end

      alias_method :build, :start

    end
  end
end

require 'biz/week_time/abstract'

require 'biz/week_time/end'
require 'biz/week_time/start'
