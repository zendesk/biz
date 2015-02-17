module Biz
  module CoreExt
  end
end

require 'biz/core_ext/date'
require 'biz/core_ext/fixnum'
require 'biz/core_ext/time'

Date.class_eval   do include Biz::CoreExt::Date   end
Fixnum.class_eval do include Biz::CoreExt::Fixnum end
Time.class_eval   do include Biz::CoreExt::Time   end
