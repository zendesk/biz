RSpec.describe Biz::DayTime do
  subject(:day_time) { described_class.new((9 * 60 + 53) * 60 + 27) }

  context 'when initializing' do
    context 'with an integer' do
      it 'is successful' do
        expect(described_class.new(1).day_second).to eq 1
      end
    end

    context 'with an valid integer-like value' do
      it 'is successful' do
        expect(described_class.new('1').day_second).to eq 1
      end
    end

    context 'with an invalid integer-like value' do
      it 'fails hard' do
        expect { described_class.new('1one') }.to raise_error ArgumentError
      end
    end

    context 'with an integer outside valid range' do
      it 'clamps value' do
        expect(described_class.new(90_000).day_second).to eq 86_400
      end
    end

    context 'with a non-integer value' do
      it 'fails hard' do
        expect { described_class.new([]) }.to raise_error TypeError
      end
    end
  end

  describe '.from_time' do
    let(:time) { Time.utc(2006, 1, 1, 9, 38, 47) }

    it 'creates a day time from the given time' do
      expect(described_class.from_time(time)).to eq(
        day_second(hour: 9, min: 38, sec: 47)
      )
    end
  end

  describe '.from_hour' do
    it 'creates a day time from the given hour' do
      expect(described_class.from_hour(9)).to eq day_second(hour: 9)
    end
  end

  describe '.from_minute' do
    it 'creates a day time from the given from' do
      expect(described_class.from_minute(day_minute(hour: 9, min: 10))).to eq(
        day_second(hour: 9, min: 10)
      )
    end
  end

  describe '.from_timestamp' do
    context 'when the timestamp is malformed' do
      let(:timestamp) { 'timestamp' }

      it 'returns nil' do
        expect(described_class.from_timestamp(timestamp)).to eq nil
      end
    end

    context 'when the timestamp is well formed' do
      context 'without seconds' do
        let(:timestamp) { '21:43' }

        it 'returns the appropriate day time' do
          expect(described_class.from_timestamp(timestamp)).to eq(
            day_second(hour: 21, min: 43)
          )
        end
      end

      context 'with seconds' do
        let(:timestamp) { '10:55:23' }

        it 'returns the appropriate day time' do
          expect(described_class.from_timestamp(timestamp)).to eq(
            day_second(hour: 10, min: 55, sec: 23)
          )
        end
      end
    end
  end

  describe '.midnight' do
    it 'creates a day time that represents midnight' do
      expect(described_class.midnight).to eq day_second(hour: 0)
    end
  end

  describe '.noon' do
    it 'creates a day time that represents noon' do
      expect(described_class.noon).to eq day_second(hour: 12)
    end
  end

  describe '.endnight' do
    it 'creates a day time that represents the end-of-day midnight' do
      expect(described_class.endnight).to eq day_second(hour: 24)
    end
  end

  describe '.am' do
    it 'creates a day time that represents an a.m. time (midnight)' do
      expect(described_class.midnight).to eq day_second(hour: 0)
    end
  end

  describe '.pm' do
    it 'creates a day time that represents a p.m. time (noon)' do
      expect(described_class.noon).to eq day_second(hour: 12)
    end
  end

  describe '#hour' do
    it 'returns the hour' do
      expect(day_time.hour).to eq 9
    end
  end

  describe '#minute' do
    it 'returns the minute' do
      expect(day_time.minute).to eq 53
    end
  end

  describe '#second' do
    it 'returns the second' do
      expect(day_time.second).to eq 27
    end
  end

  describe '#day_minute' do
    it 'returns the number of minutes into the day' do
      expect(day_time.day_minute).to eq 593
    end
  end

  describe '#timestamp' do
    context 'when the hour and minute are single-digit values' do
      subject(:day_time) { described_class.new(day_second(hour: 4, min: 3)) }

      it 'returns a zero-padded timestamp' do
        expect(day_time.timestamp).to eq '04:03'
      end
    end

    context 'when the hour and minute are double-digit values' do
      subject(:day_time) { described_class.new(day_second(hour: 15, min: 27)) }

      it 'returns a correctly formatted timestamp' do
        expect(day_time.timestamp).to eq '15:27'
      end
    end
  end

  describe '#strftime' do
    it 'returns a properly formatted string' do
      expect(day_time.strftime('%H:%M:%S %p')).to eq '09:53:27 AM'
    end
  end

  describe '#to_int' do
    it 'returns the minutes since day start' do
      expect(day_time.to_int).to eq day_second(hour: 9, min: 53, sec: 27)
    end
  end

  describe '#to_i' do
    it 'returns the minutes since day start' do
      expect(day_time.to_i).to eq day_second(hour: 9, min: 53, sec: 27)
    end
  end

  context 'when performing comparison' do
    context 'and the compared object does not respond to #to_i' do
      it 'raises an argument error' do
        expect { day_time < Object.new }.to raise_error ArgumentError
      end
    end

    context 'and the compared object responds to #to_i' do
      it 'compares as expected' do
        expect(day_time > 100).to eq true
      end
    end

    context 'and the comparing object is an integer' do
      it 'compares as expected' do
        expect(100 < day_time).to eq true
      end
    end
  end
end
