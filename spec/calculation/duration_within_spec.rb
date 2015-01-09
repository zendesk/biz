RSpec.describe Biz::Calculation::DurationWithin do
  let(:work_hours) {
    {
      mon: {'09:00' => '17:00'},
      tue: {'10:00' => '16:00'},
      wed: {'09:00' => '17:00'},
      thu: {'10:00' => '16:00'},
      fri: {'09:00' => '17:00'},
      sat: {'11:00' => '14:30'}
    }
  }
  let(:holidays)  { [] }
  let(:time_zone) { 'Etc/UTC' }

  let(:schedule) {
    Biz::Schedule.new do |config|
      config.work_hours = work_hours
      config.holidays   = holidays
      config.time_zone  = time_zone
    end
  }

  subject(:calculation) {
    described_class.new(schedule.periods, calculation_period)
  }

  context "when the calculation start time is after the end time" do
    let(:calculation_period) {
      Biz::TimeSegment.new(Time.utc(2006, 1, 8), Time.utc(2006, 1, 1))
    }

    it "returns a zero duration" do
      expect(calculation).to eq Biz::Duration.new(0)
    end
  end

  context "when the calculation start time is equal to the end time" do
    let(:calculation_period) {
      Biz::TimeSegment.new(Time.utc(2006, 1, 1), Time.utc(2006, 1, 1))
    }

    it "returns a zero duration" do
      expect(calculation).to eq Biz::Duration.new(0)
    end
  end

  context "when the calculation start time is before the end time" do
    let(:calculation_period) {
      Biz::TimeSegment.new(Time.utc(2006, 1, 1), Time.utc(2006, 1, 8))
    }

    it "returns the elapsed duration" do
      expect(calculation).to eq Biz::Duration.hours(39.5)
    end
  end
end
