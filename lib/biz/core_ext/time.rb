module Biz
  module CoreExt
    module Time
      def business_hours?
        Biz.in_hours?(self)
      end

      def on_holiday?
        Biz.on_holiday?(self)
      end
    end
  end
end
