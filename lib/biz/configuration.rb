module Biz
  class Configuration

    attr_accessor :work_hours,
                  :holidays,
                  :time_zone

    def initialize
      @work_hours = nil
      @holidays   = nil
      @time_zone  = nil

      yield self if block_given?
    end

  end
end
