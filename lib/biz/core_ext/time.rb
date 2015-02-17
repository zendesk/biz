module Biz
  module CoreExt
    module Time

      def business_hours?
        Biz.business_hours?(self)
      end

    end
  end
end
