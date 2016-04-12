RSpec.describe Biz::WeekTime::Abstract do
  let(:week_time_class) { Class.new(described_class) }

  subject(:week_time) {
    week_time_class.new(week_minute(wday: 0, hour: 9, min: 30))
  }

  context 'when initializing' do
    context 'with a valid integer-like value' do
      it 'is successful' do
        expect { week_time_class.new('1') }.not_to raise_error
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
      expect(week_time_class.from_time(time)).to eq(
        week_time_class.new(week_minute(wday: 1, hour: 9, min: 30))
      )
    end
  end

  context 'when performing comparison' do
    context 'and the compared object is an earlier week time' do
      let(:other) {
        week_time_class.new(week_minute(wday: 0, hour: 9, min: 29))
      }

      it 'compares as expected' do
        expect(week_time > other).to eq true
      end
    end

    context 'and the compared object is the same week time' do
      let(:other) {
        week_time_class.new(week_minute(wday: 0, hour: 9, min: 30))
      }

      it 'compares as expected' do
        expect(week_time == other).to eq true
      end
    end

    context 'and the other object is a later week time' do
      let(:other) {
        week_time_class.new(week_minute(wday: 0, hour: 9, min: 31))
      }

      it 'compares as expected' do
        expect(week_time < other).to eq true
      end
    end

    context 'and the other object is a week-time-like object' do
      let(:other) {
        Class.new(described_class).new(week_minute(wday: 0, hour: 9, min: 30))
      }

      it 'compares as expected' do
        expect(week_time == other).to eq true
      end
    end

    context 'and the compared object is not a week time' do
      let(:other) { 1 }

      it 'is not comparable' do
        expect { week_time < other }.to raise_error ArgumentError
      end
    end
  end
end
