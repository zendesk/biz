RSpec.describe Biz::Week do
  subject(:week) { described_class.new(2) }

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

    it "creates the proper week" do
      expect(described_class.from_date(epoch_time)).to eq 1
    end
  end

  describe ".from_time" do
    let(:epoch_time) { Time.new(2006, 1, 10) }

    it "creates the proper week" do
      expect(described_class.from_time(epoch_time)).to eq 1
    end
  end

  describe ".since_epoch" do
    let(:epoch_time) { Time.new(2006, 1, 10) }

    it "creates the proper week" do
      expect(described_class.since_epoch(epoch_time)).to eq 1
    end
  end

  describe "#start_date" do
    it "returns the corresponding date since epoch of the first day" do
      expect(week.start_date).to eq Date.new(2006, 1, 15)
    end
  end

  describe "#succ" do
    it "returns the next week" do
      expect(week.succ).to eq described_class.new(week.to_i + 1)
    end
  end

  describe "#downto" do
    it "iterates down to the provided week" do
      expect(week.downto(described_class.new(0)).to_a).to eq [
        described_class.new(2),
        described_class.new(1),
        described_class.new(0)
      ]
    end
  end

  describe "#+" do
    let(:week_1) { described_class.new(1) }
    let(:week_2) { described_class.new(2) }

    it "adds the weeks" do
      expect(week_1 + week_2).to eq described_class.new(3)
    end
  end

  describe "#to_s" do
    it "returns the week since epoch" do
      expect(week.to_s).to eq '2'
    end
  end

  describe "#to_int" do
    it "returns the week since epoch" do
      expect(week.to_int).to eq 2
    end
  end

  describe "#to_i" do
    it "returns the week since epoch" do
      expect(week.to_i).to eq 2
    end
  end

  context "when performing comparison" do
    context "and the compared object does not respond to #to_i" do
      it "raises an argument error" do
        expect { week < Object.new }.to raise_error ArgumentError
      end
    end

    context "and the compared object responds to #to_i" do
      it "compares as expected" do
        expect(week > 1).to eq true
      end
    end

    context "and the comparing object is an integer" do
      it "compares as expected" do
        expect(1 < week).to eq true
      end
    end
  end
end
