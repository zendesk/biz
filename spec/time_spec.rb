# frozen_string_literal: true

RSpec.describe Biz::Time do
  let(:time_zone) { TZInfo::Timezone.get('America/Los_Angeles') }

  subject(:time) { described_class.new(time_zone) }

  describe '.minute_seconds' do
    it 'returns the number of seconds in a minute' do
      expect(described_class.minute_seconds).to eq 60
    end
  end

  describe '.hour_minutes' do
    it 'returns the number of minutes in an hour' do
      expect(described_class.hour_minutes).to eq 60
    end
  end

  describe '.day_hours' do
    it 'returns the number of hours in a day' do
      expect(described_class.day_hours).to eq 24
    end
  end

  describe '.week_days' do
    it 'returns the number of days in a week' do
      expect(described_class.week_days).to eq 7
    end
  end

  describe '.hour_seconds' do
    it 'returns the number of seconds in an hour' do
      expect(described_class.hour_seconds).to eq(
        Biz::Time.hour_minutes * Biz::Time.minute_seconds
      )
    end
  end

  describe '.day_seconds' do
    it 'returns the number of seconds in a day' do
      expect(described_class.day_seconds).to eq(
        Biz::Time.day_minutes * Biz::Time.minute_seconds
      )
    end
  end

  describe '.day_minutes' do
    it 'returns the number of minutes in a day' do
      expect(described_class.day_minutes).to eq(
        Biz::Time.day_hours * Biz::Time.hour_minutes
      )
    end
  end

  describe '.week_minutes' do
    it 'returns the number of minutes in a week' do
      expect(described_class.week_minutes).to eq(
        Biz::Time.week_days * Biz::Time.day_minutes
      )
    end
  end

  describe '.big_bang' do
    it 'returns the beginning of time' do
      expected = Date.new(-4712, 1, 1, Date::ITALY).to_time
      expect(described_class.big_bang).to eq expected
    end
  end

  describe '.heat_death' do
    it 'returns the end of time' do
      expected = Date.new(4712, 1, 1, Date::ITALY).to_time
      expect(described_class.heat_death).to eq expected
    end
  end

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

    context 'when a non-existent (spring-forward) endnight time is targeted' do
      let(:time_zone) { TZInfo::Timezone.get('America/Sao_Paulo') }
      let(:date)      { Date.new(2015, 10, 17) }
      let(:day_time)  { Biz::DayTime.new(day_second(hour: 24)) }

      it 'returns the corresponding time an hour later' do
        expect(time.on_date(date, day_time)).to eq(
          time_zone.local_to_utc(Time.new(2015, 10, 18, 1))
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
