RSpec.describe Biz::DayOfWeek do
  subject(:day) { described_class.new(1) }

  context 'when initializing' do
    context 'with an integer' do
      it 'is successful' do
        expect(described_class.new(1)).to eq described_class.new(1)
      end
    end

    context 'with an valid integer-like value' do
      it 'is successful' do
        expect(described_class.new('1')).to eq described_class.new(1)
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
  end

  describe '.all' do
    it 'returns all the days of the week' do
      expect(described_class.all).to eq [
        described_class.new(0),
        described_class.new(1),
        described_class.new(2),
        described_class.new(3),
        described_class.new(4),
        described_class.new(5),
        described_class.new(6)
      ]
    end
  end

  describe '.from_symbol' do
    it 'creates the proper day of the week' do
      expect(described_class.from_symbol(:wed)).to eq described_class.new(3)
    end
  end

  describe '#contains?' do
    context 'when the week minute is at the beginning of the day of the week' do
      let(:minute) { week_minute(wday: 1, hour: 0) }

      it 'returns true' do
        expect(day.contains?(minute)).to eq true
      end
    end

    context 'when the week minute is in the middle of the day of the week' do
      let(:minute) { week_minute(wday: 1, hour: 12) }

      it 'returns true' do
        expect(day.contains?(minute)).to eq true
      end
    end

    context 'when the week minute is at the end of the day of the week' do
      let(:minute) { week_minute(wday: 2, hour: 0) }

      it 'returns true' do
        expect(day.contains?(minute)).to eq true
      end
    end

    context 'when the week time is not within the day of the week' do
      let(:minute) { week_minute(wday: 3, hour: 12) }

      it 'returns false' do
        expect(day.contains?(minute)).to eq false
      end
    end
  end

  describe '#start_minute' do
    it 'returns the first minute of the day of the week' do
      expect(day.start_minute).to eq week_minute(wday: 1, hour: 0)
    end
  end

  describe '#end_minute' do
    it 'returns the last minute of the day of the week' do
      expect(day.end_minute).to eq week_minute(wday: 2, hour: 0)
    end
  end

  describe '#week_minute' do
    it 'returns the corresponding week minute' do
      expect(day.week_minute(day_minute(hour: 9, min: 30))).to eq(
        week_minute(wday: 1, hour: 9, min: 30)
      )
    end
  end

  describe '#day_minute' do
    context 'when the week minute occurs in the middle of a day' do
      it 'returns the corresponding day minute' do
        expect(day.day_minute(week_minute(wday: 2, hour: 9, min: 30))).to eq(
          day_minute(hour: 9, min: 30)
        )
      end
    end

    context 'when the week minute is on the day boundary' do
      it 'returns the last minute of the day' do
        expect(day.day_minute(week_minute(wday: 2, hour: 24))).to eq(
          day_minute(hour: 24)
        )
      end
    end
  end

  describe '#symbol' do
    it 'returns the corresponding symbol for the day of the week' do
      expect(day.symbol).to eq :mon
    end
  end

  describe '#wday?' do
    context 'when the other `wday` is the same' do
      it 'returns true' do
        expect(day.wday?(1)).to eq true
      end
    end

    context 'when the other `wday` is different' do
      it 'returns false' do
        expect(day.wday?(2)).to eq false
      end
    end
  end

  context 'when performing comparison' do
    context 'and the compared object is an earlier day of the week' do
      let(:other) { described_class.new(0) }

      it 'compares as expected' do
        expect(day > other).to eq true
      end
    end

    context 'and the compared object is the same day of the week' do
      let(:other) { described_class.new(1) }

      it 'compares as expected' do
        expect(day == other).to eq true
      end
    end

    context 'and the other object is a later day of the week' do
      let(:other) { described_class.new(2) }

      it 'compares as expected' do
        expect(day < other).to eq true
      end
    end

    context 'and the compared object is not a day of the week' do
      let(:other) { 1 }

      it 'is not comparable' do
        expect { day < other }.to raise_error ArgumentError
      end
    end
  end
end
