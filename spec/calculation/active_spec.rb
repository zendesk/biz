RSpec.describe Biz::Calculation::Active do
  subject(:calculation) {
    described_class.new(
      schedule(
        breaks:   {Date.new(2006, 1, 3) => {'05:30' => '11:00'}},
        holidays: [Date.new(2006, 1, 4)]
      ),
      time
    )
  }

  describe '#result' do
    context 'when the time is not contained by an interval' do
      context 'and not on a break nor holiday' do
        let(:time) { Time.utc(2006, 1, 1, 6) }

        it 'returns false' do
          expect(calculation.result).to eq false
        end
      end

      context 'and on a break' do
        let(:time) { Time.utc(2006, 1, 3, 6) }

        it 'returns false' do
          expect(calculation.result).to eq false
        end
      end

      context 'and on a holiday' do
        let(:time) { Time.utc(2006, 1, 4, 6) }

        it 'returns false' do
          expect(calculation.result).to eq false
        end
      end
    end

    context 'when the time is contained by an interval' do
      context 'and not on a break nor holiday' do
        let(:time) { Time.utc(2006, 1, 2, 12) }

        it 'returns true' do
          expect(calculation.result).to eq true
        end
      end

      context 'and on a break' do
        let(:time) { Time.utc(2006, 1, 3, 10) }

        it 'returns false' do
          expect(calculation.result).to eq false
        end
      end

      context 'and on a holiday' do
        let(:time) { Time.utc(2006, 1, 4, 12) }

        it 'returns false' do
          expect(calculation.result).to eq false
        end
      end
    end
  end
end
