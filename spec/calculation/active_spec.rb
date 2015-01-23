RSpec.describe Biz::Calculation::Active do
  subject(:calculation) {
    described_class.new(schedule(holidays: [Date.new(2006, 1, 4)]), time)
  }

  describe '#active?' do
    context 'when the time is not contained by an interval' do
      context 'and not on a holiday' do
        let(:time) { Time.utc(2006, 1, 1, 6) }

        it 'returns false' do
          expect(calculation.active?).to eq false
        end
      end

      context 'and on a holiday' do
        let(:time) { Time.utc(2006, 1, 4, 6) }

        it 'returns false' do
          expect(calculation.active?).to eq false
        end
      end
    end

    context 'when the time is contained by an interval' do
      context 'and not on a holiday' do
        let(:time) { Time.utc(2006, 1, 2, 12) }

        it 'returns true' do
          expect(calculation.active?).to eq true
        end
      end

      context 'and on a holiday' do
        let(:time) { Time.utc(2006, 1, 4, 12) }

        it 'returns false' do
          expect(calculation.active?).to eq false
        end
      end
    end
  end
end
