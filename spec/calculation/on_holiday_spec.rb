RSpec.describe Biz::Calculation::OnHoliday do
  subject(:calculation) {
    described_class.new(schedule(holidays: [Date.new(2006, 1, 4)]), time)
  }

  describe '#result' do
    context 'when the time is at the beginning of a holiday' do
      let(:time) { Time.utc(2006, 1, 4, 0) }

      it 'returns true' do
        expect(calculation.result).to eq true
      end
    end

    context 'when the time is in the middle of a holiday' do
      let(:time) { Time.utc(2006, 1, 4, 12) }

      it 'returns true' do
        expect(calculation.result).to eq true
      end
    end

    context 'when the time is at the end of a holiday' do
      let(:time) { Time.utc(2006, 1, 4, 24) }

      it 'returns false' do
        expect(calculation.result).to eq false
      end
    end

    context 'when the time is not on a holiday' do
      let(:time) { Time.utc(2006, 1, 5, 12) }

      it 'returns false' do
        expect(calculation.result).to eq false
      end
    end
  end
end
