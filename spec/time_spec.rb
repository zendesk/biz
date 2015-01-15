RSpec.describe Biz::Time do
  let(:time_zone) { TZInfo::Timezone.get('America/Los_Angeles') }

  subject(:time) { described_class.new(time_zone) }

  describe '#on_date' do
    context 'when a normal time is targeted' do
      let(:date)     { Date.new(2006, 1, 4) }
      let(:day_time) { Biz::DayTime.new(day_minute(hour: 12, min: 30)) }

      it 'returns the corresponding UTC time' do
        expect(time.on_date(date, day_time)).to eq(
          time_zone.local_to_utc(Time.utc(2006, 1, 4, 12, 30))
        )
      end
    end

    context 'when a non-existent (spring-forward) time is targeted' do
      let(:date)     { Date.new(2014, 3, 9) }
      let(:day_time) { Biz::DayTime.new(day_minute(hour: 2, min: 30)) }

      it 'returns the corresponding time an hour later' do
        expect(time.on_date(date, day_time)).to eq(
          time_zone.local_to_utc(Time.utc(2014, 3, 9, 3, 30))
        )
      end
    end

    context 'when an ambiguous time is targeted' do
      let(:date)     { Date.new(2014, 11, 2) }
      let(:day_time) { Biz::DayTime.new(day_minute(hour: 1, min: 30)) }

      it 'returns the DST occurrence of the time' do
        expect(time.on_date(date, day_time)).to eq(
          time_zone.local_to_utc(Time.utc(2014, 11, 2, 1, 30), true)
        )
      end
    end
  end

  describe '#during_week' do
    let(:week)      { Biz::Week.new(1) }
    let(:week_time) {
      Biz::WeekTime.build(week_minute(wday: 0, hour: 1, min: 5))
    }

    let(:target_time) { time_zone.local_to_utc(Time.local(2006, 1, 8, 1, 5)) }

    it 'returns the target time' do
      expect(time.during_week(week, week_time)).to eq target_time
    end
  end
end
