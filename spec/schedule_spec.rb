RSpec.describe Biz::Schedule do
  let(:hours) {
    {
      mon: {'09:00' => '17:00'},
      tue: {'10:00' => '16:00'},
      wed: {'09:00' => '17:00'},
      thu: {'10:00' => '16:00'},
      fri: {'09:00' => '17:00'},
      sat: {'11:00' => '14:30'}
    }
  }
  let(:holidays)  { [Date.new(2006, 1, 1), Date.new(2006, 12, 25)] }
  let(:time_zone) { 'Etc/UTC' }
  let(:config)    {
    proc do |c|
      c.hours     = hours
      c.holidays  = holidays
      c.time_zone = time_zone
    end
  }

  subject(:schedule) { Biz::Schedule.new(&config) }

  describe '#intervals' do
    it 'delegates to the configuration' do
      expect(schedule.intervals).to eq Biz::Configuration.new(&config).intervals
    end
  end

  describe '#holidays' do
    it 'delegates to the configuration' do
      expect(schedule.holidays).to eq Biz::Configuration.new(&config).holidays
    end
  end

  describe '#time_zone' do
    it 'delegates to the configuration' do
      expect(schedule.time_zone).to eq Biz::Configuration.new(&config).time_zone
    end
  end

  describe '#periods' do
    let(:hours) { {mon: {'01:00' => '02:00'}} }

    it 'returns periods for the schedule' do
      expect(
        schedule.periods.after(Time.utc(2006, 1, 1)).first
      ).to eq(
        Biz::TimeSegment.new(Time.utc(2006, 1, 2, 1), Time.utc(2006, 1, 2, 2))
      )
    end
  end

  describe '#dates' do
    let(:hours) { {mon: {'09:00' => '17:00'}, fri: {'09:00' => '17:00'}} }

    it 'returns dates for the schedule' do
      expect(schedule.dates.after(Date.new(2006, 1, 1)).take(2).to_a).to eq [
        Date.new(2006, 1, 2),
        Date.new(2006, 1, 6)
      ]
    end
  end

  describe '#time' do
    it 'returns the time after an amount of elapsed business time' do
      expect(schedule.time(30, :minutes).after(Time.utc(2006, 1, 2, 9))).to eq(
        Time.utc(2006, 1, 2, 9, 30)
      )
    end
  end

  describe '#within' do
    it 'returns the amount of elapsed business time between two times' do
      expect(
        schedule.within(Time.utc(2006, 1, 2, 11), Time.utc(2006, 1, 3, 11))
      ).to eq Biz::Duration.hours(7)
    end
  end

  describe '#in_hours?' do
    context 'when the time is not in business hours' do
      let(:time) { Time.utc(2006, 1, 2, 8) }

      it 'returns false' do
        expect(schedule.in_hours?(time)).to eq false
      end
    end

    context 'when the time is in business hours' do
      let(:time) { Time.utc(2006, 1, 2, 10) }

      it 'returns true' do
        expect(schedule.in_hours?(time)).to eq true
      end
    end
  end

  describe '#business_hours?' do
    context 'when the time is not in business hours' do
      let(:time) { Time.utc(2006, 1, 2, 8) }

      it 'returns false' do
        expect(schedule.business_hours?(time)).to eq false
      end
    end

    context 'when the time is in business hours' do
      let(:time) { Time.utc(2006, 1, 2, 10) }

      it 'returns true' do
        expect(schedule.business_hours?(time)).to eq true
      end
    end
  end

  describe '#on_holiday?' do
    context 'when the time is on a holiday' do
      let(:time) { Time.utc(2006, 12, 25, 12) }

      it 'returns true' do
        expect(schedule.on_holiday?(time)).to eq true
      end
    end

    context 'when the time is not on a holiday' do
      let(:time) { Time.utc(2006, 12, 26, 12) }

      it 'returns false' do
        expect(schedule.on_holiday?(time)).to eq false
      end
    end
  end

  describe '#in_zone' do
    let(:time_zone) { 'America/Los_Angeles' }

    it 'returns a time object with its time zone' do
      expect(schedule.in_zone.local(Time.utc(2006, 1, 1, 10))).to eq(
        Time.utc(2006, 1, 1, 2)
      )
    end
  end

  describe '#&' do
    let(:other) {
      described_class.new do |config|
        config.hours = {
          sun: {'10:00' => '12:00'},
          mon: {'08:00' => '10:00'},
          tue: {'11:00' => '15:00'},
          wed: {'16:00' => '18:00'},
          thu: {'11:00' => '12:00', '13:00' => '14:00'}
        }

        config.holidays = [
          Date.new(2006, 1, 1),
          Date.new(2006, 7, 4),
          Date.new(2006, 11, 24)
        ]

        config.time_zone = 'America/Los_Angeles'
      end
    }

    it 'returns a new schedule' do
      expect(schedule & other).to be_a Biz::Schedule
    end

    it 'configures the schedule with the intersection of intervals' do
      expect(Biz::Interval.to_hours((schedule & other).intervals)).to eq(
        mon: {'09:00' => '10:00'},
        tue: {'11:00' => '15:00'},
        wed: {'16:00' => '17:00'},
        thu: {'11:00' => '12:00', '13:00' => '14:00'}
      )
    end

    it 'configures the schedule with the union of holidays' do
      expect((schedule & other).holidays.map(&:to_date)).to eq [
        Date.new(2006, 1, 1),
        Date.new(2006, 7, 4),
        Date.new(2006, 11, 24),
        Date.new(2006, 12, 25)
      ]
    end

    it 'configures the schedule with the original time zone' do
      expect((schedule & other).time_zone).to eq schedule.time_zone
    end
  end
end
