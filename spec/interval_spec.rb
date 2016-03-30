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

  describe '.to_hours' do
    let(:intervals) {
      [
        described_class.new(
          Biz::WeekTime.start(week_minute(wday: 1, hour: 9)),
          Biz::WeekTime.end(week_minute(wday: 1, hour: 17)),
          time_zone
        ),
        described_class.new(
          Biz::WeekTime.start(week_minute(wday: 2, hour: 9)),
          Biz::WeekTime.end(week_minute(wday: 2, hour: 12)),
          time_zone
        ),
        described_class.new(
          Biz::WeekTime.start(week_minute(wday: 2, hour: 13)),
          Biz::WeekTime.end(week_minute(wday: 2, hour: 17)),
          time_zone
        ),
        described_class.new(
          Biz::WeekTime.start(week_minute(wday: 4, hour: 10)),
          Biz::WeekTime.end(week_minute(wday: 4, hour: 16)),
          time_zone
        ),
        described_class.new(
          Biz::WeekTime.start(week_minute(wday: 5, hour: 9)),
          Biz::WeekTime.end(week_minute(wday: 5, hour: 17)),
          time_zone
        )
      ]
    }

    it 'returns a configuration hash for the provided intervals' do
      expect(described_class.to_hours(intervals)).to eq(
        mon: {'09:00' => '17:00'},
        tue: {'09:00' => '12:00', '13:00' => '17:00'},
        thu: {'10:00' => '16:00'},
        fri: {'09:00' => '17:00'}
      )
    end
  end

  describe '#wday_symbol' do
    let(:start_time) { week_minute(wday: 1, hour: 12) }
    let(:end_time)   { week_minute(wday: 2, hour: 12) }

    it 'returns the symbol for the day containing the start time' do
      expect(interval.wday_symbol).to eq :mon
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

  describe '#empty?' do
    context 'when the start time is before the end time' do
      let(:start_time) { end_time.pred }

      it 'returns false' do
        expect(interval.empty?).to eq false
      end
    end

    context 'when the start time is equal to the end time' do
      let(:start_time) { end_time }

      it 'returns true' do
        expect(interval.empty?).to eq true
      end
    end

    context 'when the start time is after the end time' do
      let(:start_time) { end_time.succ }

      it 'returns true' do
        expect(interval.empty?).to eq true
      end
    end
  end

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

  describe '#&' do
    let(:other) {
      described_class.new(
        Biz::WeekTime.start(other_start_time),
        Biz::WeekTime.end(other_end_time),
        time_zone
      )
    }

    context 'when the other interval occurs before the interval' do
      let(:other_start_time) { week_minute(wday: 0, hour: 9) }
      let(:other_end_time)   { week_minute(wday: 0, hour: 17) }

      it 'returns a zero-duration interval' do
        expect(interval & other).to eq(
          described_class.new(
            Biz::WeekTime.start(start_time),
            Biz::WeekTime.end(start_time),
            time_zone
          )
        )
      end
    end

    context 'when the other interval starts before the interval' do
      let(:other_start_time) { week_minute(wday: 1, hour: 8) }

      context 'and ends before the interval' do
        let(:other_end_time) { week_minute(wday: 1, hour: 12) }

        it 'returns the correct interval' do
          expect(interval & other).to eq(
            described_class.new(
              Biz::WeekTime.start(start_time),
              Biz::WeekTime.end(other_end_time),
              time_zone
            )
          )
        end
      end

      context 'and ends after the interval' do
        let(:other_end_time) { week_minute(wday: 1, hour: 18) }

        it 'returns the correct interval' do
          expect(interval & other).to eq(
            described_class.new(
              Biz::WeekTime.start(start_time),
              Biz::WeekTime.end(end_time),
              time_zone
            )
          )
        end
      end
    end

    context 'when the other interval starts after the interval' do
      let(:other_start_time) { week_minute(wday: 1, hour: 12) }

      context 'and ends before the interval' do
        let(:other_end_time) { week_minute(wday: 1, hour: 15) }

        it 'returns the correct interval' do
          expect(interval & other).to eq(
            described_class.new(
              Biz::WeekTime.start(other_start_time),
              Biz::WeekTime.end(other_end_time),
              time_zone
            )
          )
        end
      end

      context 'and ends after the interval' do
        let(:other_end_time) { week_minute(wday: 1, hour: 18) }

        it 'returns the correct interval' do
          expect(interval & other).to eq(
            described_class.new(
              Biz::WeekTime.start(other_start_time),
              Biz::WeekTime.end(end_time),
              time_zone
            )
          )
        end
      end
    end

    context 'when the other interval occurs after the interval' do
      let(:other_start_time) { week_minute(wday: 2, hour: 9) }
      let(:other_end_time)   { week_minute(wday: 2, hour: 17) }

      it 'returns a zero-duration interval' do
        expect(interval & other).to eq(
          described_class.new(
            Biz::WeekTime.start(other_start_time),
            Biz::WeekTime.end(other_start_time),
            time_zone
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
