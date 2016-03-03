RSpec.describe Biz::Interval do
  let(:start_time) { week_minute(wday: 1, hour: 9) }
  let(:end_time)   { week_minute(wday: 1, hour: 17) }
  let(:time_zone)  { TZInfo::Timezone.get('America/Los_Angeles') }

  subject(:interval) {
    described_class.new(
      Biz::WeekTime.start(start_time),
      Biz::WeekTime.end(end_time),
      time_zone
    )
  }

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
      expect(interval.endpoints).to eq [
        Biz::WeekTime.start(start_time),
        Biz::WeekTime.end(end_time)
      ]
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
      let(:start_time) { Biz::DayOfWeek.all.first.start_minute }
      let(:end_time)   { Biz::DayOfWeek.all.first.end_minute }

      it 'returns the appropriate time segment' do
        expect(interval.to_time_segment(week)).to eq(
          Biz::TimeSegment.new(
            in_zone('America/Los_Angeles') { Time.utc(2006, 1, 29) },
            in_zone('America/Los_Angeles') { Time.utc(2006, 1, 30) }
          )
        )
      end
    end

    context 'when the interval covers an entire week' do
      let(:start_time) { week_minute(wday: 0, hour: 0) }
      let(:end_time)   { Biz::Time.week_minutes }

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

  context 'when performing comparison' do
    context 'and the compared object has an earlier start time' do
      let(:other) {
        described_class.new(
          Biz::WeekTime.start(start_time - 1),
          Biz::WeekTime.end(end_time),
          time_zone
        )
      }

      it 'compares as expected' do
        expect(interval > other).to eq true
      end
    end

    context 'and the compared object has a later start time' do
      let(:other) {
        described_class.new(
          Biz::WeekTime.start(start_time + 1),
          Biz::WeekTime.end(end_time),
          time_zone
        )
      }

      it 'compares as expected' do
        expect(interval > other).to eq false
      end
    end

    context 'and the compared object has an earlier end time' do
      let(:other) {
        described_class.new(
          Biz::WeekTime.start(start_time),
          Biz::WeekTime.end(end_time - 1),
          time_zone
        )
      }

      it 'compares as expected' do
        expect(interval > other).to eq true
      end
    end

    context 'and the compared object has a different time zone' do
      let(:other) {
        described_class.new(
          Biz::WeekTime.start(start_time),
          Biz::WeekTime.end(end_time + 1),
          TZInfo::Timezone.get('America/Los_Angeles')
        )
      }

      it 'compares as expected' do
        expect(interval == other).to eq false
      end
    end

    context 'and the compared object has the same endpoints and time zone' do
      let(:other) {
        described_class.new(
          Biz::WeekTime.start(start_time),
          Biz::WeekTime.end(end_time),
          time_zone
        )
      }

      it 'compares as expected' do
        expect(interval == other).to eq true
      end
    end

    context 'and the compared object is not an interval' do
      let(:other) { 1 }

      it 'is not comparable' do
        expect { interval < other }.to raise_error ArgumentError
      end
    end
  end
end
