RSpec::Matchers.define :eq_intervals do |expected|
  match do |actual|
    intervals?(expected) && intervals?(actual) && equivalent?(expected, actual)
  end

  failure_message do |actual|
    "expected intervals: #{expected}\n" \
    "     got intervals: #{actual}"
  end

  diffable

  def intervals?(intervals)
    intervals.all? { |interval| interval.is_a?(Biz::Interval) }
  end

  def equivalent?(expected, actual)
    raw_intervals(expected) == raw_intervals(actual)
  end

  def raw_intervals(intervals)
    intervals.map { |interval|
      {
        start_time: interval.start_time,
        end_time:   interval.end_time,
        time_zone:  interval.time_zone
      }
    }
  end
end
