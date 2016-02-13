RSpec::Matchers.define :eq_holidays do |expected|
  match do |actual|
    holidays?(expected) && holidays?(actual) && equivalent?(expected, actual)
  end

  failure_message do |actual|
    "expected holidays: #{expected}\n" \
    "     got holidays: #{actual}"
  end

  diffable

  def holidays?(holidays)
    holidays.all? { |holiday| holiday.is_a?(Biz::Holiday) }
  end

  def equivalent?(expected, actual)
    raw_holidays(expected) == raw_holidays(actual)
  end

  def raw_holidays(holidays)
    holidays.map { |holiday|
      {date: holiday.date, time_zone: holiday.time_zone}
    }
  end
end
