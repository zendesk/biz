RSpec.describe Biz::Holiday do
  let(:date)      { Date.new(2010, 7, 15) }
  let(:time_zone) { TZInfo::Timezone.get('America/Los_Angeles') }

  subject(:holiday) { described_class.new(date, time_zone) }

  describe '#contain?' do
    context 'when the time is before the holiday' do
      let(:time) { in_zone('America/New_York') { Time.utc(2010, 7, 15, 2) } }

      it 'returns false' do
        expect(holiday.contain?(time)).to eq false
      end
    end

    context 'when the time is at the beginning of the holiday' do
      let(:time) { in_zone('America/New_York') { Time.utc(2010, 7, 15, 3) } }

      it 'returns true' do
        expect(holiday.contain?(time)).to eq true
      end
    end

    context 'when the time is contained by the holiday' do
      let(:time) { in_zone('America/New_York') { Time.utc(2010, 7, 15, 15) } }

      it 'returns true' do
        expect(holiday.contain?(time)).to eq true
      end
    end

    context 'when the time is at the end of the holiday' do
      let(:time) { in_zone('America/New_York') { Time.utc(2010, 7, 16, 3) } }

      it 'returns false' do
        expect(holiday.contain?(time)).to eq false
      end
    end

    context 'when the time is after the holiday' do
      let(:time) { in_zone('America/New_York') { Time.utc(2010, 7, 16, 4) } }

      it 'returns false' do
        expect(holiday.contain?(time)).to eq false
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
end
