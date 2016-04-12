RSpec.describe Biz::Calculation::ForDuration do
  context 'when initializing' do
    context 'with a valid integer-like scalar' do
      it 'is successful' do
        expect { described_class.new(schedule, '1') }.not_to raise_error
      end
    end

    context 'with an invalid integer-like scalar' do
      it 'fails hard' do
        expect {
          described_class.new(schedule, '1one')
        }.to raise_error ArgumentError
      end
    end

    context 'with a non-integer scalar' do
      it 'fails hard' do
        expect { described_class.new(schedule, []) }.to raise_error TypeError
      end
    end

    context 'with a negative scalar' do
      it 'fails hard' do
        expect {
          described_class.new(schedule, -1)
        }.to raise_error ArgumentError
      end
    end

    context 'with a zero scalar' do
      it 'is successful' do
        expect { described_class.new(schedule, 0) }.not_to raise_error
      end
    end

    context 'with a positive scalar' do
      it 'is successful' do
        expect { described_class.new(schedule, 1) }.not_to raise_error
      end
    end
  end

  describe '.units' do
    it 'returns the supported units' do
      expect(described_class.units).to eq(
        %i[second seconds minute minutes hour hours day days]
      )
    end
  end

  describe '.with_unit' do
    context 'when called with a supported unit' do
      it 'returns a calculation with the unit' do
        expect(
          described_class
            .with_unit(schedule, 1, :hour)
            .after(Time.utc(2006, 1, 2, 10))
        ).to eq(
          described_class.hours(schedule, 1).after(Time.utc(2006, 1, 2, 10))
        )
      end
    end

    context 'when called with an unsupported unit' do
      it 'fails hard' do
        expect {
          described_class.with_unit(schedule, 1, :parsec)
        }.to raise_error ArgumentError
      end
    end
  end

  %i[second seconds].each do |unit|
    describe ".#{unit}" do
      let(:scalar) { 90 }

      subject(:calculation) { described_class.send(unit, schedule, scalar) }

      describe '#before' do
        let(:time) { Time.utc(2006, 1, 4, 16, 1, 30) }

        it 'returns the backward time after the elapsed duration' do
          expect(calculation.before(time)).to eq Time.utc(2006, 1, 4, 16)
        end

        context 'when the scalar is zero' do
          let(:scalar) { 0 }
          let(:time)   { Time.utc(2006, 1, 3) }

          it 'returns the first active moment backward in time' do
            expect(calculation.before(time)).to eq Time.utc(2006, 1, 2, 17)
          end
        end
      end

      describe '#after' do
        let(:time) { Time.utc(2006, 1, 4, 15, 58, 30) }

        it 'returns the forward time after the elapsed duration' do
          expect(calculation.after(time)).to eq Time.utc(2006, 1, 4, 16)
        end

        context 'when the scalar is zero' do
          let(:scalar) { 0 }
          let(:time)   { Time.utc(2006, 1, 3) }

          it 'returns the first active moment forward in time' do
            expect(calculation.after(time)).to eq Time.utc(2006, 1, 3, 10)
          end
        end
      end
    end
  end

  %i[minute minutes].each do |unit|
    describe ".#{unit}" do
      let(:scalar) { 90 }

      subject(:calculation) { described_class.send(unit, schedule, scalar) }

      describe '#before' do
        let(:time) { Time.utc(2006, 1, 4, 16, 30) }

        it 'returns the backward time after the elapsed duration' do
          expect(calculation.before(time)).to eq Time.utc(2006, 1, 4, 15)
        end

        context 'when the scalar is zero' do
          let(:scalar) { 0 }
          let(:time)   { Time.utc(2006, 1, 3) }

          it 'returns the first active moment backward in time' do
            expect(calculation.before(time)).to eq Time.utc(2006, 1, 2, 17)
          end
        end
      end

      describe '#after' do
        let(:time) { Time.utc(2006, 1, 4, 15, 30) }

        it 'returns the forward time after the elapsed duration' do
          expect(calculation.after(time)).to eq Time.utc(2006, 1, 4, 17)
        end

        context 'when the scalar is zero' do
          let(:scalar) { 0 }
          let(:time)   { Time.utc(2006, 1, 3) }

          it 'returns the first active moment forward in time' do
            expect(calculation.after(time)).to eq Time.utc(2006, 1, 3, 10)
          end
        end
      end
    end
  end

  %i[hour hours].each do |unit|
    describe ".#{unit}" do
      let(:scalar) { 3 }

      subject(:calculation) { described_class.send(unit, schedule, scalar) }

      describe '#before' do
        let(:time) { Time.utc(2006, 1, 4, 17) }

        it 'returns the backward time after the elapsed duration' do
          expect(calculation.before(time)).to eq Time.utc(2006, 1, 4, 14)
        end

        context 'when the scalar is zero' do
          let(:scalar) { 0 }
          let(:time)   { Time.utc(2006, 1, 3) }

          it 'returns the first active moment backward in time' do
            expect(calculation.before(time)).to eq Time.utc(2006, 1, 2, 17)
          end
        end
      end

      describe '#after' do
        let(:time) { Time.utc(2006, 1, 4, 14) }

        it 'returns the forward time after the elapsed duration' do
          expect(calculation.after(time)).to eq Time.utc(2006, 1, 4, 17)
        end

        context 'when the scalar is zero' do
          let(:scalar) { 0 }
          let(:time)   { Time.utc(2006, 1, 3) }

          it 'returns the first active moment forward in time' do
            expect(calculation.after(time)).to eq Time.utc(2006, 1, 3, 10)
          end
        end
      end
    end
  end

  %i[day days].each do |unit|
    describe ".#{unit}" do
      let(:scalar) { 2 }

      subject(:calculation) { described_class.send(unit, schedule, scalar) }

      describe '#before' do
        context 'when the advanced time is within a period' do
          let(:time) { Time.utc(2006, 1, 9, 12) }

          it 'returns the time advanced by the number of business days' do
            expect(calculation.before(time)).to eq Time.utc(2006, 1, 6, 12)
          end
        end

        context 'when the advanced time is before the first day period' do
          let(:time) { Time.utc(2006, 1, 5, 8) }

          it 'returns the next time before the advanced time' do
            expect(calculation.before(time)).to eq Time.utc(2006, 1, 2, 17)
          end
        end

        context 'when the advanced time is after the last day period' do
          let(:time) { Time.utc(2006, 1, 5, 18) }

          it 'returns the next time before the advanced time' do
            expect(calculation.before(time)).to eq Time.utc(2006, 1, 3, 16)
          end
        end

        context 'when the time has second precision' do
          let(:time) { Time.utc(2006, 1, 9, 12, 30, 52) }

          it 'retains second precision' do
            expect(calculation.before(time)).to eq(
              Time.utc(2006, 1, 6, 12, 30, 52)
            )
          end
        end

        context 'when the scalar is zero' do
          let(:scalar) { 0 }
          let(:time)   { Time.utc(2006, 1, 2, 14) }

          it 'returns the first active moment backward in time' do
            expect(calculation.before(time)).to eq Time.utc(2006, 1, 2, 14)
          end
        end
      end

      describe '#after' do
        context 'when the advanced time is within a period' do
          let(:time) { Time.utc(2006, 1, 6, 12) }

          it 'returns the time advanced by the number of business days' do
            expect(calculation.after(time)).to eq Time.utc(2006, 1, 9, 12)
          end
        end

        context 'when the advanced time is before the first day period' do
          let(:time) { Time.utc(2006, 1, 3, 8) }

          it 'returns the next time after the advanced time' do
            expect(calculation.after(time)).to eq Time.utc(2006, 1, 5, 10)
          end
        end

        context 'when the advanced time is after the last day period' do
          let(:time) { Time.utc(2006, 1, 3, 18) }

          it 'returns the next time after the advanced time' do
            expect(calculation.after(time)).to eq Time.utc(2006, 1, 6, 9)
          end
        end

        context 'when the time has second precision' do
          let(:time) { Time.utc(2006, 1, 6, 12, 30, 52) }

          it 'retains second precision' do
            expect(calculation.after(time)).to eq(
              Time.utc(2006, 1, 9, 12, 30, 52)
            )
          end
        end

        context 'when the scalar is zero' do
          let(:scalar) { 0 }
          let(:time)   { Time.utc(2006, 1, 2, 13) }

          it 'returns the first active moment forward in time' do
            expect(calculation.after(time)).to eq Time.utc(2006, 1, 2, 13)
          end
        end
      end
    end
  end
end
