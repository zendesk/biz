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
        Biz::WeekTime.start(Biz::DayOfWeek.all.first.start_minute)
      }
      let(:end_time) {
        Biz::WeekTime.end(Biz::DayOfWeek.all.first.end_minute)
      }

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
      let(:start_time) { Biz::WeekTime.start(0) }
      let(:end_time)   { Biz::WeekTime.end(Biz::Time.week_minutes) }

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

  describe '#==' do
    context 'when the start time is not the same' do
      let(:other_interval) {
        described_class.new(
          Biz::WeekTime.start(interval.start_time.week_minute + 1),
          interval.end_time,
          interval.time_zone
        )
      }

      it 'returns false' do
        expect(interval == other_interval).to eq false
      end
    end

    context 'when the end time is not the same' do
      let(:other_interval) {
        described_class.new(
          interval.start_time,
          Biz::WeekTime.end(interval.end_time.week_minute + 1),
          interval.time_zone
        )
      }

      it 'returns false' do
        expect(interval == other_interval).to eq false
      end
    end

    context 'when the time zone is not the same' do
      let(:other_interval) {
        described_class.new(
          interval.start_time,
          interval.end_time,
          TZInfo::Timezone.get('America/New_York')
        )
      }

      it 'returns false' do
        expect(interval == other_interval).to eq false
      end
    end

    context 'when the start time, end time, and time zone are the same' do
      let(:other_interval) {
        described_class.new(
          interval.start_time,
          interval.end_time,
          interval.time_zone
        )
      }

      it 'returns true' do
        expect(interval == other_interval).to eq true
      end
    end
  end

  describe '#eql?' do
    let(:other_interval) {
      described_class.new(
        interval.start_time,
        interval.end_time,
        interval.time_zone
      )
    }

    it 'aliases `==`' do
      expect(interval.eql?(other_interval)).to eq interval == other_interval
    end
  end
end
