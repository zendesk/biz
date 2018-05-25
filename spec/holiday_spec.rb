# frozen_string_literal: true

RSpec.describe Biz::Holiday do
  let(:date)      { Date.new(2010, 7, 15) }
  let(:time_zone) { TZInfo::Timezone.get('America/Los_Angeles') }

  subject(:holiday) { described_class.new(date, time_zone) }

  describe '#contains?' do
    context 'when the time is before the holiday' do
      let(:time) { in_zone('America/New_York') { Time.utc(2010, 7, 15, 2) } }

      it 'returns false' do
        expect(holiday.contains?(time)).to eq false
      end
    end

    context 'when the time is at the beginning of the holiday' do
      let(:time) { in_zone('America/New_York') { Time.utc(2010, 7, 15, 3) } }

      it 'returns true' do
        expect(holiday.contains?(time)).to eq true
      end
    end

    context 'when the time is contained by the holiday' do
      let(:time) { in_zone('America/New_York') { Time.utc(2010, 7, 15, 15) } }

      it 'returns true' do
        expect(holiday.contains?(time)).to eq true
      end
    end

    context 'when the time is at the end of the holiday' do
      let(:time) { in_zone('America/New_York') { Time.utc(2010, 7, 16, 3) } }

      it 'returns false' do
        expect(holiday.contains?(time)).to eq false
      end
    end

    context 'when the time is after the holiday' do
      let(:time) { in_zone('America/New_York') { Time.utc(2010, 7, 16, 4) } }

      it 'returns false' do
        expect(holiday.contains?(time)).to eq false
      end
    end
  end

  describe '#to_time_segment' do
    it 'returns the appropriate time segment' do
      expect(holiday.to_time_segment).to eq(
        Biz::TimeSegment.new(
          in_zone('America/Los_Angeles') { Time.utc(2010, 7, 15) },
          in_zone('America/Los_Angeles') { Time.utc(2010, 7, 16) }
        )
      )
    end
  end

  describe '#to_date' do
    it 'returns the appropriate date' do
      expect(holiday.to_date).to eq Date.new(2010, 7, 15)
    end
  end

  context 'when performing comparison' do
    context 'and the compared object has an earlier date' do
      let(:other) { described_class.new(date.prev_day, time_zone) }

      it 'compares as expected' do
        expect(holiday > other).to eq true
      end
    end

    context 'and the compared object has a later date' do
      let(:other) { described_class.new(date.next_day, time_zone) }

      it 'compares as expected' do
        expect(holiday > other).to eq false
      end
    end

    context 'and the compared object has a different time zone' do
      let(:other) {
        described_class.new(date, TZInfo::Timezone.get('America/New_York'))
      }

      it 'compares as expected' do
        expect(holiday == other).to eq false
      end
    end

    context 'and the compared object has the same date and time zone' do
      let(:other) { described_class.new(date, time_zone) }

      it 'compares as expected' do
        expect(holiday == other).to eq true
      end
    end

    context 'and the compared object is not a holiday' do
      let(:other) { 1 }

      it 'is not comparable' do
        expect { holiday < other }.to raise_error ArgumentError
      end
    end
  end
end
