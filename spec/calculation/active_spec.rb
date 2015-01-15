RSpec.describe Biz::Calculation::Active do
  subject(:calculation) { described_class.new(schedule.periods, time) }

  describe '#active?' do
    context 'when the time is not outside all intervals' do
      let(:time) { Time.utc(2006, 1, 1, 9) }

      it 'returns false' do
        expect(calculation.active?).to eq false
      end
    end

    context 'when the time is at the beginning of an interval' do
      let(:time) { Time.utc(2006, 1, 2, 9) }

      it 'returns true' do
        expect(calculation.active?).to eq true
      end
    end

    context 'when the time is at the end of an interval' do
      let(:time) { Time.utc(2006, 1, 2, 17) }

      it 'returns true' do
        expect(calculation.active?).to eq true
      end
    end

    context 'when the time is contained by an interval' do
      let(:time) { Time.utc(2006, 1, 2, 12) }

      it 'returns true' do
        expect(calculation.active?).to eq true
      end
    end
  end
end
