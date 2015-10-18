RSpec.describe Biz::Time do
  let(:time_zone) { TZInfo::Timezone.get('America/Los_Angeles') }

  subject(:time) { described_class.new(time_zone) }

  describe '#local' do
    let(:provided_time) {
      in_zone('America/New_York') { Time.utc(2006, 1, 1, 12, 30, 15) }
    }

    it 'converts the time to the equivalent in the specified time zone' do
      expect(time.local(provided_time)).to eq Time.utc(2006, 1, 1, 9, 30, 15)
    end
  end

  describe '#on_date' do
    context 'when a normal time is targeted' do
      let(:date)     { Date.new(2006, 1, 4) }
      let(:day_time) { Biz::DayTime.new(day_second(hour: 12, min: 30, sec: 9)) }

      it 'returns the corresponding UTC time' do
        expect(time.on_date(date, day_time)).to eq(
          time_zone.local_to_utc(Time.utc(2006, 1, 4, 12, 30, 9))
        )
      end
    end

    context 'when a non-existent (spring-forward) time is targeted' do
      let(:date)     { Date.new(2014, 3, 9) }
      let(:day_time) { Biz::DayTime.new(day_second(hour: 2, min: 30)) }

      it 'returns the corresponding time an hour later' do
        expect(time.on_date(date, day_time)).to eq(
          time_zone.local_to_utc(Time.utc(2014, 3, 9, 3, 30))
        )
      end
    end

    context 'when the time an hour later is invalid' do
      let(:date)     { Date.new(2014, 3, 9) }
      let(:day_time) { Biz::DayTime.new(day_second(hour: 25, min: 0)) }

      it 'gets clamped to a valid value' do
        expect(time.on_date(date, day_time)).to eq(
          time_zone.local_to_utc(Time.utc(2014, 3, 10, 0, 0))
        )
      end
    end

    context 'when an ambiguous time is targeted' do
      let(:date)     { Date.new(2014, 11, 2) }
      let(:day_time) { Biz::DayTime.new(day_second(hour: 1, min: 30)) }

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

    it 'returns the target time' do
      expect(time.during_week(week, week_time)).to eq(
        time_zone.local_to_utc(Time.utc(2006, 1, 8, 1, 5))
      )
    end
  end

  context 'when a non-existent (spring-forward) time is targeted' do
    let(:week)      { Biz::Week.new(427) }
    let(:week_time) {
      Biz::WeekTime.build(week_minute(wday: 0, hour: 2, min: 30))
    }

    it 'returns the target time an hour later' do
      expect(time.during_week(week, week_time)).to eq(
        time_zone.local_to_utc(Time.utc(2014, 3, 9, 3, 30))
      )
    end
  end

  context 'when an ambiguous time is targeted' do
    let(:week)      { Biz::Week.new(461) }
    let(:week_time) {
      Biz::WeekTime.build(week_minute(wday: 0, hour: 1, min: 30))
    }

    it 'returns the DST occurrence of the target time' do
      expect(time.during_week(week, week_time)).to eq(
        time_zone.local_to_utc(Time.utc(2014, 11, 2, 1, 30), true)
      )
    end
  end
end
