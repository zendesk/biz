module Biz
  module CoreExt
    module Fixnum
      Calculation::ForDuration.units.each do |unit|
        define_method("business_#{unit}") { Biz.time(self, unit) }
      end
    end
  end
end
