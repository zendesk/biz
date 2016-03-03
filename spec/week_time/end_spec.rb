RSpec.describe Biz::WeekTime::End do
  subject(:week_time) {
    described_class.new(week_minute(wday: 0, hour: 9, min: 30))
  }

  describe '#wday' do
    context 'when the time is contained within a day' do
      subject(:week_time) {
        described_class.new(week_minute(wday: 0, hour: 12))
      }

      it 'returns the weekday integer for that day' do
        expect(week_time.wday).to eq 0
      end
    end

    context 'when the time is on a day boundary' do
      subject(:week_time) {
        described_class.new(week_minute(wday: 1, hour: 0))
      }

      it 'returns the weekday integer for the endnight day' do
        expect(week_time.wday).to eq 0
      end
    end

    context 'when the time is the last minute of the week' do
      subject(:week_time) {
        described_class.new(week_minute(wday: 7, hour: 0))
      }

      it 'returns the weekday integer for Saturday' do
        expect(week_time.wday).to eq 6
      end
    end
  end

  describe '#wday_symbol' do
    context 'when the time is contained within a day' do
      subject(:week_time) {
        described_class.new(week_minute(wday: 0, hour: 12))
      }

      it 'returns the weekday symbol for that day' do
        expect(week_time.wday_symbol).to eq :sun
      end
    end

    context 'when the time is on a day boundary' do
      subject(:week_time) {
        described_class.new(week_minute(wday: 1, hour: 0))
      }

      it 'returns the weekday symbol for the endnight day' do
        expect(week_time.wday_symbol).to eq :sun
      end
    end
  end

  describe '#day_time' do
    it 'returns the corresponding day time' do
      expect(week_time.day_time).to eq(
        Biz::DayTime.new(day_second(hour: 9, min: 30))
      )
    end
  end

  describe '#day_minute' do
    it 'returns the corresponding day minute' do
      expect(week_time.day_minute).to eq day_minute(hour: 9, min: 30)
    end
  end

  describe '#day_second' do
    it 'returns the corresponding day second' do
      expect(week_time.day_second).to eq day_second(hour: 9, min: 30)
    end
  end

  describe '#hour' do
    it 'returns the corresponding hour' do
      expect(week_time.hour).to eq 9
    end
  end

  describe '#minute' do
    it 'returns the corresponding minute' do
      expect(week_time.minute).to eq 30
    end
  end

  describe '#timestamp' do
    it 'returns the corresponding timestamp' do
      expect(week_time.timestamp).to eq '09:30'
    end
  end

  context 'when the week minute is on a day boundary' do
    subject(:week_time) {
      described_class.new(Biz::DayOfWeek.all.first.end_minute)
    }

    describe '#day_time' do
      it 'returns the endnight day time' do
        expect(week_time.day_time).to eq Biz::DayTime.new(Biz::Time.day_seconds)
      end
    end

    describe '#day_minute' do
      it 'returns the number of minutes in a day' do
        expect(week_time.day_minute).to eq Biz::Time.day_minutes
      end
    end

    describe '#hour' do
      it 'returns 24' do
        expect(week_time.hour).to eq 24
      end
    end

    describe '#minute' do
      it 'returns zero' do
        expect(week_time.minute).to eq 0
      end
    end

    describe '#timestamp' do
      it "returns '24:00'" do
        expect(week_time.timestamp).to eq '24:00'
      end
    end
  end
end
