# frozen_string_literal: true

RSpec.describe Biz::Configuration do
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

  let(:shifts) {
    {
      Date.new(2006, 1, 4) => {'10:00' => '14:00'},
      Date.new(2006, 1, 5) => {'11:00' => '13:00', '14:00' => '16:00'}
    }
  }

  let(:breaks) {
    {
      Date.new(2006, 1, 2) => {'10:00' => '11:30'},
      Date.new(2006, 1, 3) => {'14:15' => '14:30', '15:40' => '15:50'}
    }
  }

  let(:holidays)  { [Date.new(2006, 1, 1), Date.new(2006, 12, 25)] }
  let(:time_zone) { 'America/New_York' }

  subject(:configuration) {
    Biz::Configuration.new do |config|
      config.hours     = hours
      config.shifts    = shifts
      config.breaks    = breaks
      config.holidays  = holidays
      config.time_zone = time_zone
    end
  }

  context 'when initialized without a block' do
    it 'does not blow up' do
      expect { described_class.new }.not_to raise_error
    end
  end

  context 'when initialized with an invalid configuration' do
    it 'raises a configuration error' do
      expect {
        Biz::Configuration.new do |config|
          config.hours = {}
        end
      }.to raise_error Biz::Error::Configuration
    end
  end

  context 'when converted to a proc for configuration' do
    let(:proc_configuration) { described_class.new(&configuration) }

    it 'configures the intervals' do
      expect(proc_configuration.intervals).to eq configuration.intervals
    end

    it 'configures the shifts' do
      expect(proc_configuration.shifts).to eq configuration.shifts
    end

    it 'configures the holidays' do
      expect(proc_configuration.holidays).to eq configuration.holidays
    end

    it 'configures the time zone' do
      expect(proc_configuration.time_zone).to eq configuration.time_zone
    end
  end

  describe '#intervals' do
    context 'when unconfigured' do
      subject(:configuration) {
        Biz::Configuration.new do |config| config.time_zone = time_zone end
      }

      it 'returns the default set of intervals' do
        expect(configuration.intervals).to eq(
          (1..5).map { |wday|
            Biz::Interval.new(
              Biz::WeekTime.start(week_minute(wday: wday, hour: 9)),
              Biz::WeekTime.end(week_minute(wday: wday, hour: 17)),
              TZInfo::Timezone.get('America/New_York')
            )
          }
        )
      end
    end

    context 'when configured using #business_hours=' do
      subject(:configuration) {
        Biz::Configuration.new do |config| config.business_hours = hours end
      }

      it 'returns the proper number of intervals' do
        expect(configuration.intervals.count).to eq 6
      end
    end

    it 'returns the proper intervals' do
      expect(configuration.intervals).to eq [
        Biz::Interval.new(
          Biz::WeekTime.start(week_minute(wday: 1, hour: 9)),
          Biz::WeekTime.end(week_minute(wday: 1, hour: 17)),
          TZInfo::Timezone.get('America/New_York')
        ),
        Biz::Interval.new(
          Biz::WeekTime.start(week_minute(wday: 2, hour: 10)),
          Biz::WeekTime.end(week_minute(wday: 2, hour: 16)),
          TZInfo::Timezone.get('America/New_York')
        ),
        Biz::Interval.new(
          Biz::WeekTime.start(week_minute(wday: 3, hour: 9)),
          Biz::WeekTime.end(week_minute(wday: 3, hour: 17)),
          TZInfo::Timezone.get('America/New_York')
        ),
        Biz::Interval.new(
          Biz::WeekTime.start(week_minute(wday: 4, hour: 10)),
          Biz::WeekTime.end(week_minute(wday: 4, hour: 16)),
          TZInfo::Timezone.get('America/New_York')
        ),
        Biz::Interval.new(
          Biz::WeekTime.start(week_minute(wday: 5, hour: 9)),
          Biz::WeekTime.end(week_minute(wday: 5, hour: 17)),
          TZInfo::Timezone.get('America/New_York')
        ),
        Biz::Interval.new(
          Biz::WeekTime.start(week_minute(wday: 6, hour: 11)),
          Biz::WeekTime.end(week_minute(wday: 6, hour: 14, min: 30)),
          TZInfo::Timezone.get('America/New_York')
        )
      ]
    end

    context 'when the weekdays are configured out of order' do
      let(:hours) { {mon: {'09:00' => '17:00'}, tue: {'10:00' => '16:00'}} }

      it 'returns the intervals in order' do
        expect(configuration.intervals).to eq [
          Biz::Interval.new(
            Biz::WeekTime.start(week_minute(wday: 1, hour: 9)),
            Biz::WeekTime.end(week_minute(wday: 1, hour: 17)),
            TZInfo::Timezone.get('America/New_York')
          ),
          Biz::Interval.new(
            Biz::WeekTime.start(week_minute(wday: 2, hour: 10)),
            Biz::WeekTime.end(week_minute(wday: 2, hour: 16)),
            TZInfo::Timezone.get('America/New_York')
          )
        ]
      end
    end
  end

  describe '#shifts' do
    it 'returns the proper shifts' do
      expect(configuration.shifts).to eq [
        Biz::TimeSegment.new(
          in_zone(time_zone) { Time.new(2006, 1, 4, 10) },
          in_zone(time_zone) { Time.new(2006, 1, 4, 14) }
        ),
        Biz::TimeSegment.new(
          in_zone(time_zone) { Time.new(2006, 1, 5, 11) },
          in_zone(time_zone) { Time.new(2006, 1, 5, 13) }
        ),
        Biz::TimeSegment.new(
          in_zone(time_zone) { Time.new(2006, 1, 5, 14) },
          in_zone(time_zone) { Time.new(2006, 1, 5, 16) }
        )
      ]
    end

    context 'when unconfigured' do
      subject(:configuration) { Biz::Configuration.new do end }

      it 'returns the default set of shifts' do
        expect(configuration.shifts).to eq []
      end
    end
  end

  describe '#breaks' do
    it 'returns the proper breaks' do
      expect(configuration.breaks).to eq [
        Biz::TimeSegment.new(
          in_zone(time_zone) { Time.new(2006, 1, 2, 10) },
          in_zone(time_zone) { Time.new(2006, 1, 2, 11, 30) }
        ),
        Biz::TimeSegment.new(
          in_zone(time_zone) { Time.new(2006, 1, 3, 14, 15) },
          in_zone(time_zone) { Time.new(2006, 1, 3, 14, 30) }
        ),
        Biz::TimeSegment.new(
          in_zone(time_zone) { Time.new(2006, 1, 3, 15, 40) },
          in_zone(time_zone) { Time.new(2006, 1, 3, 15, 50) }
        )
      ]
    end

    context 'when unconfigured' do
      subject(:configuration) { Biz::Configuration.new do end }

      it 'returns the default set of breaks' do
        expect(configuration.breaks).to eq []
      end
    end
  end

  describe '#holidays' do
    let(:holidays) {
      [Date.new(2006, 12, 25), Date.new(2006, 1, 1), Date.new(2006, 7, 4)]
    }

    it 'returns the proper holidays' do
      expect(configuration.holidays).to eq [
        Biz::Holiday.new(
          Date.new(2006, 1, 1),
          TZInfo::Timezone.get('America/New_York')
        ),
        Biz::Holiday.new(
          Date.new(2006, 7, 4),
          TZInfo::Timezone.get('America/New_York')
        ),
        Biz::Holiday.new(
          Date.new(2006, 12, 25),
          TZInfo::Timezone.get('America/New_York')
        )
      ]
    end

    context 'when unconfigured' do
      subject(:configuration) { Biz::Configuration.new do end }

      it 'returns the default set of holidays' do
        expect(configuration.holidays).to eq []
      end
    end

    context 'when configured with duplicate holidays' do
      let(:holidays) { Array.new(3) { Date.new(2006, 1, 1) } }

      it 'removes the duplicate dates' do
        expect(configuration.holidays).to eq [
          Biz::Holiday.new(
            Date.new(2006, 1, 1),
            TZInfo::Timezone.get('America/New_York')
          )
        ]
      end
    end

    context 'when configured with an array-like object' do
      let(:holidays) {
        Class.new do
          def initialize(holidays)
            @holidays = holidays
          end

          def to_a
            @holidays
          end
        end.new([Date.new(2006, 1, 1)])
      }

      it 'does not blow up' do
        expect { configuration.holidays }.not_to raise_error
      end
    end
  end

  describe '#time_zone' do
    context 'when unconfigured' do
      subject(:configuration) { Biz::Configuration.new do end }

      it 'returns the default time zone' do
        expect(configuration.time_zone).to eq TZInfo::Timezone.get('Etc/UTC')
      end
    end

    it 'returns the proper time zone object' do
      expect(configuration.time_zone).to eq(
        TZInfo::Timezone.get('America/New_York')
      )
    end
  end

  describe '#weekdays' do
    it 'returns the active weekdays for the configured schedule' do
      expect(configuration.weekdays).to eq %i[mon tue wed thu fri sat]
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

        config.shifts = {Date.new(2006, 1, 15) => {'19:00' => '19:30'}}

        config.breaks = {Date.new(2006, 1, 3) => {'11:15' => '11:45'}}

        config.holidays = [
          Date.new(2006, 1, 1),
          Date.new(2006, 7, 4),
          Date.new(2006, 11, 24)
        ]

        config.time_zone = 'Etc/UTC'
      end
    }

    it 'returns a new configuration' do
      expect(configuration & other).to be_a Biz::Configuration
    end

    it 'intersects the intervals' do
      expect(Biz::Interval.to_hours((configuration & other).intervals)).to eq(
        mon: {'09:00' => '10:00'},
        tue: {'11:00' => '15:00'},
        wed: {'16:00' => '17:00'},
        thu: {'11:00' => '12:00', '13:00' => '14:00'}
      )
    end

    it 'uses no shifts' do
      expect((configuration & other).shifts).to eq []
    end

    it 'combines the breaks' do
      expect((configuration & other).breaks).to eq [
        Biz::TimeSegment.new(
          in_zone('America/New_York') { Time.new(2006, 1, 2, 10) },
          in_zone('America/New_York') { Time.new(2006, 1, 2, 11, 30) }
        ),
        Biz::TimeSegment.new(
          in_zone('America/New_York') { Time.new(2006, 1, 3, 11, 15) },
          in_zone('America/New_York') { Time.new(2006, 1, 3, 11, 45) }
        ),
        Biz::TimeSegment.new(
          in_zone('America/New_York') { Time.new(2006, 1, 3, 14, 15) },
          in_zone('America/New_York') { Time.new(2006, 1, 3, 14, 30) }
        ),
        Biz::TimeSegment.new(
          in_zone('America/New_York') { Time.new(2006, 1, 3, 15, 40) },
          in_zone('America/New_York') { Time.new(2006, 1, 3, 15, 50) }
        )
      ]
    end

    it 'combines the holidays' do
      expect((configuration & other).holidays.map(&:to_date)).to eq [
        Date.new(2006, 1, 1),
        Date.new(2006, 7, 4),
        Date.new(2006, 11, 24),
        Date.new(2006, 12, 25)
      ]
    end

    it 'uses the original time zone' do
      expect((configuration & other).time_zone).to eq configuration.time_zone
    end
  end
end
