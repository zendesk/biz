RSpec.describe Biz::Interval do
  let(:start_time) { Biz::WeekTime.start(week_minute(wday: 1, hour: 9)) }
  let(:end_time)   { Biz::WeekTime.end(week_minute(wday: 1, hour: 17)) }
  let(:time_zone)  { TZInfo::Timezone.get('America/Los_Angeles') }

  subject(:interval) { described_class.new(start_time, end_time, time_zone) }

  describe '#contains?' do
    context 'when the time is before the interval' do
      let(:time) { in_zone('America/New_York') { Time.utc(2006, 1, 2, 11) } }

      it 'returns false' do
        expect(interval.contains?(time)).to eq false
      end
    end

    context 'when the time is at the beginning of the interval' do
      let(:time) { in_zone('America/New_York') { Time.utc(2006, 1, 2, 12) } }

      it 'returns true' do
        expect(interval.contains?(time)).to eq true
      end
    end

    context 'when the time is contained by the interval' do
      let(:time) { in_zone('America/New_York') { Time.utc(2006, 1, 2, 15) } }

      it 'returns true' do
        expect(interval.contains?(time)).to eq true
      end
    end

    context 'when the time is at the end of the interval' do
      let(:time) { in_zone('America/New_York') { Time.utc(2006, 1, 2, 20) } }

      it 'returns false' do
        expect(interval.contains?(time)).to eq false
      end
    end

    context 'when the time is after the interval' do
      let(:time) { in_zone('America/New_York') { Time.utc(2006, 1, 2, 21) } }

      it 'returns false' do
        expect(interval.contains?(time)).to eq false
      end
    end
  end

  describe '#endpoints' do
    it 'returns the interval endpoints' do
      expect(interval.endpoints).to eq [start_time, end_time]
    end
  end

  describe '#to_time_segment' do
    let(:week) { Biz::Week.new(4) }

    it 'returns the appropriate time segment for the given week' do
      expect(interval.to_time_segment(week)).to eq(
        Biz::TimeSegment.new(
          in_zone('America/Los_Angeles') { Time.utc(2006, 1, 30, 9) },
          in_zone('America/Los_Angeles') { Time.utc(2006, 1, 30, 17) }
        )
      )
    end

    context 'when the interval covers an entire day' do
      let(:start_time) {
        Biz::WeekTime.start(Biz::DayOfWeek::MONDAY.start_minute)
      }
      let(:end_time) {
        Biz::WeekTime.end(Biz::DayOfWeek::MONDAY.end_minute)
      }

      it 'returns the appropriate time segment' do
        expect(interval.to_time_segment(week)).to eq(
          Biz::TimeSegment.new(
            in_zone('America/Los_Angeles') { Time.utc(2006, 1, 30) },
            in_zone('America/Los_Angeles') { Time.utc(2006, 1, 31) }
          )
        )
      end
    end

    context 'when the interval covers an entire week' do
      let(:start_time) { Biz::WeekTime.start(0) }
      let(:end_time)   { Biz::WeekTime.end(Biz::Time::MINUTES_IN_WEEK) }

      it 'returns the appropriate time segment' do
        expect(interval.to_time_segment(week)).to eq(
          Biz::TimeSegment.new(
            in_zone('America/Los_Angeles') { Time.utc(2006, 1, 29) },
            in_zone('America/Los_Angeles') { Time.utc(2006, 2, 5) }
          )
        )
      end
    end
  end
end
