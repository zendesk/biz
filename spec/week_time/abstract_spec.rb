RSpec.describe Biz::WeekTime::Abstract do
  let(:week_time_class) { Class.new(described_class) }

  subject(:week_time) {
    week_time_class.new(week_minute(wday: 0, hour: 9, min: 30))
  }

  context 'when initializing' do
    context 'with an integer' do
      it 'is successful' do
        expect(week_time_class.new(1).week_minute).to eq 1
      end
    end

    context 'with an valid integer-like value' do
      it 'is successful' do
        expect(week_time_class.new('1').week_minute).to eq 1
      end
    end

    context 'with an invalid integer-like value' do
      it 'fails hard' do
        expect { week_time_class.new('1one') }.to raise_error ArgumentError
      end
    end

    context 'with a non-integer value' do
      it 'fails hard' do
        expect { week_time_class.new([]) }.to raise_error TypeError
      end
    end
  end

  describe '.from_time' do
    let(:time) { Time.utc(2006, 1, 9, 9, 30) }

    it 'creates the proper week time' do
      expect(week_time_class.from_time(time)).to(
        eq week_minute(wday: 1, hour: 9, min: 30)
      )
    end
  end

  describe '#to_int' do
    it 'returns the minutes since week start' do
      expect(week_time.to_int).to eq week_minute(wday: 0, hour: 9, min: 30)
    end
  end

  describe '#to_i' do
    it 'returns the minutes since week start' do
      expect(week_time.to_i).to eq week_minute(wday: 0, hour: 9, min: 30)
    end
  end

  context 'when performing comparison' do
    context 'and the compared object does not respond to #to_i' do
      it 'raises an argument error' do
        expect { week_time < Object.new }.to raise_error ArgumentError
      end
    end

    context 'and the compared object responds to #to_i' do
      it 'compares as expected' do
        expect(week_time > 100).to eq true
      end
    end

    context 'and the comparing object is an integer' do
      it 'compares as expected' do
        expect(100 < week_time).to eq true
      end
    end
  end
end
