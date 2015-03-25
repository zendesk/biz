module Biz
  module CoreExt
    module Time
      def business_hours?
        Biz.in_hours?(self)
      end
    end
  end
end
