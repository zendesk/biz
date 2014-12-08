RSpec.describe Biz::DayTime do
  subject(:day_time) { described_class.new(9 * 60 + 30) }

  context "when initializing" do
    context "with an integer" do
      it "is successful" do
        expect(described_class.new(1).day_minute).to eq 1
      end
    end

    context "with an valid integer-like value" do
      it "is successful" do
        expect(described_class.new('1').day_minute).to eq 1
      end
    end

    context "with an invalid integer-like value" do
      it "fails hard" do
        expect { described_class.new('1one') }.to raise_error ArgumentError
      end
    end

    context "with a non-integer value" do
      it "fails hard" do
        expect { described_class.new([]) }.to raise_error TypeError
      end
    end
  end

  describe ".from_hour" do
    it "creates a day time from the given hour" do
      expect(described_class.from_hour(9).day_minute).to eq day_minute(hour: 9)
    end
  end

  describe ".from_week_time" do
    let(:week_time) {
      Biz::WeekTime.new(week_minute(wday: 3, hour: 7, min: 30))
    }

    it "creates a day time from the given week_time" do
      expect(described_class.from_week_time(week_time).day_minute).to(
        eq day_minute(hour: 7, min: 30)
      )
    end
  end

  describe ".from_timestamp" do
    context "when the timestamp is malformed" do
      let(:timestamp) { 'timestamp' }

      it "returns nil" do
        expect(described_class.from_timestamp(timestamp)).to eq nil
      end
    end

    context "when the timestamp is well formed" do
      let(:timestamp) { '21:43' }

      it "returns the appropriate day time" do
        expect(described_class.from_timestamp(timestamp)).to eq(
          day_minute(hour: 21, min: 43)
        )
      end
    end
  end

  describe ".midnight" do
    it "creates a day time that represents midnight" do
      expect(described_class.midnight.day_minute).to eq day_minute(hour: 0)
    end
  end

  describe ".noon" do
    it "creates a day time that represents noon" do
      expect(described_class.noon.day_minute).to eq day_minute(hour: 12)
    end
  end

  describe ".endnight" do
    it "creates a day time that represents the end-of-day midnight" do
      expect(described_class.endnight.day_minute).to eq day_minute(hour: 24)
    end
  end

  describe ".am" do
    it "creates a day time that represents an a.m. time (midnight)" do
      expect(described_class.midnight.day_minute).to eq day_minute(hour: 0)
    end
  end

  describe ".pm" do
    it "creates a day time that represents a p.m. time (noon)" do
      expect(described_class.noon.day_minute).to eq day_minute(hour: 12)
    end
  end

  describe "#hour" do
    it "returns the hour" do
      expect(day_time.hour).to eq 9
    end
  end

  describe "#minute" do
    it "returns the minute" do
      expect(day_time.minute).to eq 30
    end
  end

  describe "#timestamp" do
    context "when the hour and minute are single-digit values" do
      subject(:day_time) { described_class.new(day_minute(hour: 4, min: 3)) }

      it "returns a zero-padded timestamp" do
        expect(day_time.timestamp).to eq '04:03'
      end
    end

    context "when the hour and minute are double-digit values" do
      subject(:day_time) { described_class.new(day_minute(hour: 15, min: 27)) }

      it "returns a correctly formatted timestamp" do
        expect(day_time.timestamp).to eq '15:27'
      end
    end
  end

  describe "#strftime" do
    it "returns a properly formatted string" do
      expect(day_time.strftime('%H:%M %p')).to eq '09:30 AM'
    end
  end

  describe "#to_int" do
    it "returns the minutes since day start" do
      expect(day_time.to_int).to eq day_minute(hour: 9, min: 30)
    end
  end

  describe "#to_i" do
    it "returns the minutes since day start" do
      expect(day_time.to_i).to eq day_minute(hour: 9, min: 30)
    end
  end

  context "when performing comparison" do
    context "and the compared object does not respond to #to_i" do
      it "raises an argument error" do
        expect { day_time < Object.new }.to raise_error ArgumentError
      end
    end

    context "and the compared object responds to #to_i" do
      it "compares as expected" do
        expect(day_time > 100).to eq true
      end
    end

    context "and the comparing object is an integer" do
      it "compares as expected" do
        expect(100 < day_time).to eq true
      end
    end
  end
end
