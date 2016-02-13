RSpec::Matchers.define :eq_time_segment do |expected|
  match do |actual|
    time_segment?(expected) &&
      time_segment?(actual) &&
      equivalent?(expected, actual)
  end

  failure_message do |actual|
    "expected time segment: #{expected}\n" \
    "     got time segment: #{actual}"
  end

  diffable

  def time_segment?(time_segment)
    time_segment.is_a?(Biz::TimeSegment)
  end

  def equivalent?(expected, actual)
    raw_time_segment(expected) == raw_time_segment(actual)
  end

  def raw_time_segment(time_segment)
    {start_time: time_segment.start_time, end_time: time_segment.end_time}
  end
end
