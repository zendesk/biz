RSpec.describe Biz::Date do
  describe '.from_day' do
    let(:built_date) { described_class.from_day(960) }

    it 'builds a date with the correct year' do
      expect(built_date.year).to eq 2008
    end

    it 'builds a date with the correct month' do
      expect(built_date.month).to eq 8
    end

    it 'builds a date with the correct day' do
      expect(built_date.mday).to eq 18
    end

    it 'returns a Date object' do
      expect(built_date).to be_instance_of Date
    end
  end

  describe '.for_dst' do
    let(:date) { Date.new(2006, 1, 1) }

    context 'when the day time is midnight' do
      let(:day_time) { Biz::DayTime.midnight }

      it 'returns the same date' do
        expect(described_class.for_dst(date, day_time)).to eq date
      end
    end

    context 'when the day time is noon' do
      let(:day_time) { Biz::DayTime.noon }

      it 'returns the same date' do
        expect(described_class.for_dst(date, day_time)).to eq date
      end
    end

    context 'when the day time is one hour before endnight' do
      let(:day_time) { Biz::DayTime.new(day_second(hour: 23)) }

      it 'returns the next date' do
        expect(described_class.for_dst(date, day_time)).to eq date.next_day
      end
    end

    context 'when the day time is endnight' do
      let(:day_time) { Biz::DayTime.endnight }

      it 'returns the next date' do
        expect(described_class.for_dst(date, day_time)).to eq date.next_day
      end
    end
  end
end
