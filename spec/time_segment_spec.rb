RSpec.describe Biz::TimeSegment do
  let(:start_time) { Time.utc(2006, 1, 8, 9, 30) }
  let(:end_time)   { Time.utc(2006, 1, 22, 17) }

  subject(:time_segment) { described_class.new(start_time, end_time) }

  describe '.before' do
    it 'returns the time segment before the provided time' do
      expect(described_class.before(start_time)).to eq(
        described_class.new(Biz::Time.big_bang, start_time)
      )
    end
  end

  describe '.after' do
    it 'returns the time segment after the provided time' do
      expect(described_class.after(start_time)).to eq(
        described_class.new(start_time, Biz::Time.heat_death)
      )
    end
  end

  describe '#duration' do
    it 'returns the duration of the time segment in seconds' do
      expect(time_segment.duration).to eq(
        Biz::Duration.new(end_time - start_time)
      )
    end
  end

  describe '#endpoints' do
    it 'returns the endpoints' do
      expect(time_segment.endpoints).to eq [
        time_segment.start_time,
        time_segment.end_time
      ]
    end
  end

  describe '#empty?' do
    context 'when the start time equals the end time' do
      let(:time_segment) { described_class.new(start_time, start_time) }

      it 'returns true' do
        expect(time_segment.empty?).to eq true
      end
    end

    context 'when the start time does not equal the end time' do
      let(:time_segment) { described_class.new(start_time, end_time) }

      it 'returns false' do
        expect(time_segment.empty?).to eq false
      end
    end
  end

  describe '#contains?' do
    context 'when the time is before the start time' do
      let(:time) { start_time - 1 }

      it 'returns false' do
        expect(time_segment.contains?(time)).to eq false
      end
    end

    context 'when the time equals the start time' do
      let(:time) { start_time }

      it 'returns true' do
        expect(time_segment.contains?(time)).to eq true
      end
    end

    context 'when the time is between the start and end times' do
      let(:time) { start_time + 1 }

      it 'returns true' do
        expect(time_segment.contains?(time)).to eq true
      end
    end

    context 'when the time equals the end time' do
      let(:time) { end_time }

      it 'returns true' do
        expect(time_segment.contains?(time)).to eq true
      end
    end

    context 'when the time is after the end time' do
      let(:time) { end_time + 1 }

      it 'returns false' do
        expect(time_segment.contains?(time)).to eq false
      end
    end
  end

  describe '#&' do
    let(:other) { described_class.new(other_start_time, other_end_time) }

    context 'when the other segment occurs before the time segment' do
      let(:other_start_time) { Time.utc(2006, 1, 1) }
      let(:other_end_time)   { Time.utc(2006, 1, 2) }

      it 'returns a zero-duration time segment' do
        expect(time_segment & other).to eq(
          described_class.new(start_time, start_time)
        )
      end
    end

    context 'when the other segment starts before the time segment' do
      let(:other_start_time) { Time.utc(2006, 1, 7) }

      context 'and ends before the time segment' do
        let(:other_end_time) { Time.utc(2006, 1, 8, 11, 45) }

        it 'returns the correct time segment' do
          expect(time_segment & other).to eq(
            described_class.new(start_time, other_end_time)
          )
        end
      end

      context 'and ends after the time segment' do
        let(:other_end_time) { Time.utc(2006, 1, 23) }

        it 'returns the correct time segment' do
          expect(time_segment & other).to eq(
            described_class.new(start_time, end_time)
          )
        end
      end
    end

    context 'when the other segment starts after the time segment' do
      let(:other_start_time) { Time.utc(2006, 1, 8, 11, 30) }

      context 'and ends before the time segment' do
        let(:other_end_time) { Time.utc(2006, 1, 9, 12, 30) }

        it 'returns the correct time segment' do
          expect(time_segment & other).to eq(
            described_class.new(other_start_time, other_end_time)
          )
        end
      end

      context 'and ends after the time segment' do
        let(:other_end_time) { Time.utc(2006, 1, 23) }

        it 'returns the correct time segment' do
          expect(time_segment & other).to eq(
            described_class.new(other_start_time, end_time)
          )
        end
      end
    end

    context 'when the other segment occurs after the time segment' do
      let(:other_start_time) { Time.utc(2006, 2, 1) }
      let(:other_end_time)   { Time.utc(2006, 2, 7) }

      it 'returns a zero-duration time segment' do
        expect(time_segment & other).to eq(
          described_class.new(other_start_time, other_start_time)
        )
      end
    end
  end

  describe '#/' do
    let(:other) { described_class.new(other_start_time, other_end_time) }

    context 'when the other segment occurs before the time segment' do
      let(:other_start_time) { Time.utc(2006, 1, 1) }
      let(:other_end_time)   { Time.utc(2006, 1, 2) }

      it 'returns the original time segment' do
        expect(time_segment / other).to eq [time_segment]
      end
    end

    context 'when the other segment starts before the time segment' do
      let(:other_start_time) { Time.utc(2006, 1, 7) }

      context 'and ends before the time segment' do
        let(:other_end_time) { Time.utc(2006, 1, 8, 11, 45) }

        it 'returns the correct time segment' do
          expect(time_segment / other).to eq [
            described_class.new(other.end_time, time_segment.end_time)
          ]
        end
      end

      context 'and ends after the time segment' do
        let(:other_end_time) { Time.utc(2006, 1, 23) }

        it 'returns an empty array' do
          expect(time_segment / other).to eq []
        end
      end
    end

    context 'when the other segment starts after the time segment' do
      let(:other_start_time) { Time.utc(2006, 1, 8, 11, 30) }

      context 'and ends before the time segment' do
        let(:other_end_time) { Time.utc(2006, 1, 9, 12, 30) }

        it 'returns the correct time segments' do
          expect(time_segment / other).to eq [
            described_class.new(time_segment.start_time, other.start_time),
            described_class.new(other.end_time, time_segment.end_time)
          ]
        end
      end

      context 'and ends after the time segment' do
        let(:other_end_time) { Time.utc(2006, 1, 23) }

        it 'returns the correct time segment' do
          expect(time_segment / other).to eq [
            described_class.new(time_segment.start_time, other.start_time)
          ]
        end
      end
    end

    context 'when the other segment occurs after the time segment' do
      let(:other_start_time) { Time.utc(2006, 2, 1) }
      let(:other_end_time)   { Time.utc(2006, 2, 7) }

      it 'returns the original time segment' do
        expect(time_segment / other).to eq [time_segment]
      end
    end
  end

  describe '#==' do
    context 'when the start time is not the same' do
      let(:other_time_segment) {
        described_class.new(time_segment.start_time + 1, time_segment.end_time)
      }

      it 'returns false' do
        expect(time_segment == other_time_segment).to eq false
      end
    end

    context 'when the end time is not the same' do
      let(:other_time_segment) {
        described_class.new(time_segment.start_time, time_segment.end_time + 1)
      }

      it 'returns false' do
        expect(time_segment == other_time_segment).to eq false
      end
    end

    context 'when the start time and end time are the same' do
      let(:other_time_segment) {
        described_class.new(time_segment.start_time, time_segment.end_time)
      }

      it 'returns true' do
        expect(time_segment == other_time_segment).to eq true
      end
    end
  end

  describe '#eql?' do
    let(:other_time_segment) {
      described_class.new(time_segment.start_time, time_segment.end_time)
    }

    it 'aliases `==`' do
      expect(time_segment.eql?(other_time_segment)).to eq(
        time_segment == other_time_segment
      )
    end
  end
end
