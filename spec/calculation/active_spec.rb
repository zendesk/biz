RSpec.describe Biz::Calculation::Active do
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

  subject(:calculation) { described_class.new(schedule.periods, time) }

  describe "#active?" do
    context "when the time is not outside all intervals" do
      let(:time) { Time.utc(2006, 1, 1, 9) }

      it "returns false" do
        expect(calculation.active?).to eq false
      end
    end

    context "when the time is at the beginning of an interval" do
      let(:time) { Time.utc(2006, 1, 2, 9) }

      it "returns true" do
        expect(calculation.active?).to eq true
      end
    end

    context "when the time is at the end of an interval" do
      let(:time) { Time.utc(2006, 1, 2, 17) }

      it "returns true" do
        expect(calculation.active?).to eq true
      end
    end

    context "when the time is contained by an interval" do
      let(:time) { Time.utc(2006, 1, 2, 12) }

      it "returns true" do
        expect(calculation.active?).to eq true
      end
    end
  end
end
