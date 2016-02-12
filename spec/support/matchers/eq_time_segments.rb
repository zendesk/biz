RSpec::Matchers.define :eq_time_segments do |expected|
  match do |actual|
    time_segments?(expected) &&
      time_segments?(actual) &&
      equivalent?(expected, actual)
  end

  failure_message do |actual|
    "expected time segments: #{expected}\n" \
    "     got time segments: #{actual}"
  end

  diffable

  def time_segments?(time_segments)
    time_segments.all? { |time_segment| time_segment.is_a?(Biz::TimeSegment) }
  end

  def equivalent?(expected, actual)
    raw_time_segments(expected) == raw_time_segments(actual)
  end

  def raw_time_segments(time_segments)
    time_segments.map { |time_segment|
      {start_time: time_segment.start_time, end_time: time_segment.end_time}
    }
  end
end
