RSpec.describe Biz::Calculation::ForDuration do
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

  subject(:calculation) { described_class.new(schedule.periods, duration) }

  context "when initializing" do
    context "with a positive duration" do
      it "is successful" do
        expect(described_class.new([], Biz::Duration.hour(1)).duration).to eq(
          Biz::Duration.hour(1)
        )
      end
    end

    context "with a negative duration" do
      it "fails hard" do
        expect {
          described_class.new([], Biz::Duration.hour(-1))
        }.to raise_error ArgumentError
      end
    end

    context "with a zero duration" do
      it "fails hard" do
        expect {
          described_class.new([], Biz::Duration.hour(0))
        }.to raise_error ArgumentError
      end
    end
  end

  describe "#before" do
    let(:duration) { Biz::Duration.hours(19) }
    let(:time)     { Time.utc(2006, 1, 4, 16) }

    it "returns the backward time after the elapsed duration" do
      expect(calculation.before(time)).to eq Time.utc(2006, 1, 2, 11)
    end
  end

  describe "#after" do
    let(:duration) { Biz::Duration.hours(19) }
    let(:time)     { Time.utc(2006, 1, 2, 11) }

    it "returns the forward time after the elapsed duration" do
      expect(calculation.after(time)).to eq Time.utc(2006, 1, 4, 16)
    end
  end
end
