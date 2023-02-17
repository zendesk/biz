# frozen_string_literal: true

RSpec.describe Biz::DayTime do
  subject(:day_time) {
    described_class.new(day_second(hour: 9, min: 53, sec: 27))
  }

  context 'when initializing' do
    context 'with a valid integer-like value' do
      it 'is successful' do
        expect { described_class.new('1') }.not_to raise_error
      end
    end

    context 'with an invalid integer-like value' do
      it 'fails hard' do
        expect { described_class.new('1one') }.to raise_error ArgumentError
      end
    end

    context 'with a non-integer value' do
      it 'fails hard' do
        expect { described_class.new([]) }.to raise_error TypeError
      end
    end

    context 'with a negative value' do
      it 'fails hard' do
        expect { described_class.new(-1) }.to raise_error ArgumentError
      end
    end

    context 'when a zero value' do
      it 'is successful' do
        expect { described_class.new(0).day_second }.not_to raise_error
      end
    end

    context 'when the value is the number of seconds in a day' do
      it 'is successful' do
        expect { described_class.new(Biz::Time.day_seconds) }.not_to raise_error
      end
    end

    context 'when the value is more than the number of seconds in a day' do
      it 'fails hard' do
        expect {
          described_class.new(Biz::Time.day_seconds + 1)
        }.to raise_error ArgumentError
      end
    end
  end

  describe '.from_time' do
    let(:time) { Time.utc(2006, 1, 1, 9, 38, 47) }

    it 'creates a day time from the given time' do
      expect(described_class.from_time(time)).to eq(
        described_class.new(day_second(hour: 9, min: 38, sec: 47))
      )
    end
  end

  describe '.from_hour' do
    it 'creates a day time from the given hour' do
      expect(described_class.from_hour(9)).to eq(
        described_class.new(day_second(hour: 9))
      )
    end
  end

  describe '.from_minute' do
    it 'creates a day time from the given from' do
      expect(described_class.from_minute(day_minute(hour: 9, min: 10))).to eq(
        described_class.new(day_second(hour: 9, min: 10))
      )
    end
  end

  describe '.from_timestamp' do
    context 'when the timestamp is not a timestamp' do
      let(:timestamp) { 'timestamp' }

      it 'raises a configuration error' do
        expect {
          described_class.from_timestamp(timestamp)
        }.to raise_error Biz::Error::Configuration
      end
    end

    context 'when the timestamp is in `H:MM` format' do
      let(:timestamp) { '5:35' }

      it 'raises a configuration error' do
        expect {
          described_class.from_timestamp(timestamp)
        }.to raise_error Biz::Error::Configuration
      end
    end

    context 'when the timestamp is in `HH:M` format' do
      let(:timestamp) { '12:3' }

      it 'raises a configuration error' do
        expect {
          described_class.from_timestamp(timestamp)
        }.to raise_error Biz::Error::Configuration
      end
    end

    context 'when the timestamp is in `HH:MM:S` format' do
      let(:timestamp) { '11:35:3' }

      it 'raises a configuration error' do
        expect {
          described_class.from_timestamp(timestamp)
        }.to raise_error Biz::Error::Configuration
      end
    end

    context 'when the timestamp is in `HH:MM` format' do
      let(:timestamp) { '21:43' }

      it 'returns the appropriate day time' do
        expect(described_class.from_timestamp(timestamp)).to eq(
          described_class.new(day_second(hour: 21, min: 43))
        )
      end
    end

    context 'when the timestamp is in `HH:MM:SS` format' do
      let(:timestamp) { '10:55:23' }

      it 'returns the appropriate day time' do
        expect(described_class.from_timestamp(timestamp)).to eq(
          described_class.new(day_second(hour: 10, min: 55, sec: 23))
        )
      end
    end
  end

  describe '.midnight' do
    it 'creates a day time that represents midnight' do
      expect(described_class.midnight).to eq(
        described_class.new(day_second(hour: 0))
      )
    end
  end

  describe '.endnight' do
    it 'creates a day time that represents the end-of-day midnight' do
      expect(described_class.endnight).to eq(
        described_class.new(day_second(hour: 24))
      )
    end
  end

  describe '#day_second' do
    it 'returns the number of seconds into the day' do
      expect(day_time.day_second).to eq day_second(hour: 9, min: 53, sec: 27)
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

  describe '#for_dst' do
    context 'when the day time is midnight' do
      let(:day_time) { Biz::DayTime.midnight }

      it 'returns a day time one hour later' do
        expect(day_time.for_dst).to eq described_class.new(day_second(hour: 1))
      end
    end

    context 'when the day time is noon' do
      let(:day_time) { Biz::DayTime.new(day_second(hour: 12)) }

      it 'returns a day time one hour later' do
        expect(day_time.for_dst).to eq described_class.new(day_second(hour: 13))
      end
    end

    context 'when the day time is one hour before endnight' do
      let(:day_time) { Biz::DayTime.new(day_second(hour: 23)) }

      it 'returns a midnight day time' do
        expect(day_time.for_dst).to eq described_class.midnight
      end
    end

    context 'when the day time is less than one hour before endnight' do
      let(:day_time) { Biz::DayTime.new(day_second(hour: 23, min: 40)) }

      it 'returns a day time just after midnight' do
        expect(day_time.for_dst).to eq(
          described_class.new(day_second(hour: 0, min: 40))
        )
      end
    end

    context 'when the day time is endnight' do
      let(:day_time) { Biz::DayTime.endnight }

      it 'returns a day time one hour after midnight' do
        expect(day_time.for_dst).to eq described_class.new(day_second(hour: 1))
      end
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

  context 'when performing comparison' do
    context 'and the compared object is an earlier day time' do
      let(:other) { described_class.new(day_second(hour: 9, min: 53, sec: 26)) }

      it 'compares as expected' do
        expect(day_time > other).to eq true
      end
    end

    context 'and the compared object is the same day time' do
      let(:other) { described_class.new(day_second(hour: 9, min: 53, sec: 27)) }

      it 'compares as expected' do
        expect(day_time == other).to eq true
      end
    end

    context 'and the other object is a later day time' do
      let(:other) { described_class.new(day_second(hour: 9, min: 53, sec: 28)) }

      it 'compares as expected' do
        expect(day_time < other).to eq true
      end
    end

    context 'and the compared object is not a day time' do
      let(:other) { 1 }

      it 'is not comparable' do
        expect { day_time < other }.to raise_error ArgumentError
      end
    end
  end
end
