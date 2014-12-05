require 'date'

module Biz
  class Date

    EPOCH = ::Date.new(1970, 1, 1)

    def self.from_day(day)
      EPOCH + day
    end

  end
end
