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
      expect(holiday.to_time_segment).to eq_time_segment(
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

  describe '#==' do
    context 'when the date is not the same' do
      let(:other_holiday) {
        described_class.new(holiday.date.next_day, holiday.time_zone)
      }

      it 'returns false' do
        expect(holiday == other_holiday).to eq false
      end
    end

    context 'when the time zone is not the same' do
      let(:other_holiday) {
        described_class.new(
          holiday.date,
          TZInfo::Timezone.get('America/New_York')
        )
      }

      it 'returns false' do
        expect(holiday == other_holiday).to eq false
      end
    end

    context 'when the date and time zone are the same' do
      let(:other_holiday) {
        described_class.new(holiday.date, holiday.time_zone)
      }

      it 'returns true' do
        expect(holiday == other_holiday).to eq true
      end
    end
  end

  describe '#eql?' do
    let(:other_holiday) { described_class.new(holiday.date, holiday.time_zone) }

    it 'aliases `==`' do
      expect(holiday.eql?(other_holiday)).to eq holiday == other_holiday
    end
  end
end
