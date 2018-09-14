# frozen_string_literal: true

RSpec.describe Biz::Calculation::Active do
  subject(:calculation) {
    described_class.new(
      schedule(
        shifts: {
          Date.new(2006, 1, 7)  => {'09:00' => '11:00'},
          Date.new(2006, 1, 10) => {'09:00' => '11:00'},
          Date.new(2006, 1, 11) => {'09:00' => '11:00'}
        },
        breaks: {
          Date.new(2006, 1, 3)  => {'05:30' => '11:00'},
          Date.new(2006, 1, 10) => {'05:30' => '11:00'}
        },
        holidays: [Date.new(2006, 1, 4), Date.new(2006, 1, 11)]
      ),
      time
    )
  }

  describe '#result' do
    context 'when the time is contained neither by an interval nor a shift' do
      context 'and during neither a break nor a holiday' do
        let(:time) { Time.utc(2006, 1, 1, 6) }

        it 'returns false' do
          expect(calculation.result).to eq false
        end
      end

      context 'and during a break' do
        let(:time) { Time.utc(2006, 1, 3, 6) }

        it 'returns false' do
          expect(calculation.result).to eq false
        end
      end

      context 'and during a holiday' do
        let(:time) { Time.utc(2006, 1, 4, 6) }

        it 'returns false' do
          expect(calculation.result).to eq false
        end
      end
    end

    context 'when the time is contained by an interval' do
      context 'and during neither a break nor a holiday' do
        let(:time) { Time.utc(2006, 1, 2, 12) }

        it 'returns true' do
          expect(calculation.result).to eq true
        end
      end

      context 'and during a break' do
        let(:time) { Time.utc(2006, 1, 3, 10) }

        it 'returns false' do
          expect(calculation.result).to eq false
        end
      end

      context 'and during a holiday' do
        let(:time) { Time.utc(2006, 1, 4, 12) }

        it 'returns false' do
          expect(calculation.result).to eq false
        end
      end

      context 'on a date with a shift' do
        let(:time) { Time.utc(2006, 1, 7, 12) }

        it 'returns false' do
          expect(calculation.result).to eq false
        end
      end
    end

    context 'when the time is contained by a shift' do
      context 'and during neither a break nor a holiday' do
        let(:time) { Time.utc(2006, 1, 7, 10) }

        it 'returns true' do
          expect(calculation.result).to eq true
        end
      end

      context 'and during a break' do
        let(:time) { Time.utc(2006, 1, 10, 10) }

        it 'returns false' do
          expect(calculation.result).to eq false
        end
      end

      context 'and during a holiday' do
        let(:time) { Time.utc(2006, 1, 11, 12) }

        it 'returns false' do
          expect(calculation.result).to eq false
        end
      end
    end
  end
end
