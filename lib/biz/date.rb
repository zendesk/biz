module Biz
  class Date

    EPOCH = ::Date.new(2006, 1, 1)

    def self.from_day(day)
      EPOCH + day
    end

  end
end
