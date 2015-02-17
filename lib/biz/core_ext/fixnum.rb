module Biz
  module CoreExt
    module Fixnum

      %i[second seconds minute minutes hour hours].each do |unit|
        define_method("business_#{unit}") { Biz.time(self, unit) }
      end

    end
  end
end
