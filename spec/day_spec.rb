RSpec.describe Biz::Day do
  subject(:day) { described_class.new(9) }

  context "when initializing" do
    context "with an integer" do
      it "is successful" do
        expect(described_class.new(1)).to be_truthy
      end
    end

    context "with an valid integer-like value" do
      it "is successful" do
        expect(described_class.new('1')).to be_truthy
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

  describe ".from_date" do
    let(:epoch_time) { Date.new(2006, 1, 10) }

    it "creates the proper day" do
      expect(described_class.from_date(epoch_time)).to eq 9
    end
  end

  describe ".from_time" do
    let(:epoch_time) { Time.new(2006, 1, 10) }

    it "creates the proper day" do
      expect(described_class.from_time(epoch_time)).to eq 9
    end
  end

  describe ".since_epoch" do
    let(:epoch_time) { Time.new(2006, 1, 10) }

    it "creates the proper day" do
      expect(described_class.since_epoch(epoch_time)).to eq 9
    end
  end

  describe "#to_date" do
    it "returns the corresponding date since epoch" do
      expect(day.to_date).to eq Date.new(2006, 1, 10)
    end
  end

  describe "#to_s" do
    it "returns the day since epoch" do
      expect(day.to_s).to eq 9.to_s
    end
  end

  describe "#to_int" do
    it "returns the day since epoch" do
      expect(day.to_int).to eq 9
    end
  end

  describe "#to_i" do
    it "returns the day since epoch" do
      expect(day.to_i).to eq 9
    end
  end

  context "when performing comparison" do
    context "and the compared object does not respond to #to_i" do
      it "raises an argument error" do
        expect { day < Object.new }.to raise_error ArgumentError
      end
    end

    context "and the compared object responds to #to_i" do
      it "compares as expected" do
        expect(day > 5).to eq true
      end
    end

    context "and the comparing object is an integer" do
      it "compares as expected" do
        expect(5 < day).to eq true
      end
    end
  end
end
