RSpec.describe Biz::Periods::After do
  let(:holidays) { [Date.new(2006, 1, 16), Date.new(2006, 1, 18)] }
  let(:origin)   { Time.utc(2006, 1, 1) }

  subject(:periods) {
    described_class.new(schedule(holidays: holidays), origin)
  }

  context "when one week of periods is requested" do
    let(:origin) { Time.utc(2006, 1, 1) }

    it "returns the proper intervals" do
      expect(periods.take(6).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 2, 9),
          Time.utc(2006, 1, 2, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 3, 10),
          Time.utc(2006, 1, 3, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 4, 9),
          Time.utc(2006, 1, 4, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 5, 10),
          Time.utc(2006, 1, 5, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 6, 9),
          Time.utc(2006, 1, 6, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 11),
          Time.utc(2006, 1, 7, 14, 30)
        )
      ]
    end
  end

  context "when multiple weeks of periods are requested" do
    let(:origin) { Time.utc(2006, 1, 1) }

    it "returns the proper intervals" do
      expect(periods.take(12).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 2, 9),
          Time.utc(2006, 1, 2, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 3, 10),
          Time.utc(2006, 1, 3, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 4, 9),
          Time.utc(2006, 1, 4, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 5, 10),
          Time.utc(2006, 1, 5, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 6, 9),
          Time.utc(2006, 1, 6, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 11),
          Time.utc(2006, 1, 7, 14, 30)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 9, 9),
          Time.utc(2006, 1, 9, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 10, 10),
          Time.utc(2006, 1, 10, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 11, 9),
          Time.utc(2006, 1, 11, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 12, 10),
          Time.utc(2006, 1, 12, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 13, 9),
          Time.utc(2006, 1, 13, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 14, 11),
          Time.utc(2006, 1, 14, 14, 30)
        )
      ]
    end
  end

  context "when the origin is outside a period" do
    let(:origin) { Time.utc(2006, 1, 1) }

    it "returns a full period first" do
      expect(periods.first).to eq(
        Biz::TimeSegment.new(Time.utc(2006, 1, 2, 9), Time.utc(2006, 1, 2, 17))
      )
    end
  end

  context "when the origin is inside a period" do
    let(:origin) { Time.utc(2006, 1, 2, 12) }

    it "returns a partial period first" do
      expect(periods.first).to eq(
        Biz::TimeSegment.new(Time.utc(2006, 1, 2, 12), Time.utc(2006, 1, 2, 17))
      )
    end
  end

  context "when a period on a holiday is encountered" do
    let(:origin) { Time.utc(2006, 1, 14) }

    it "does not include that period" do
      expect(periods.take(2).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 14, 11),
          Time.utc(2006, 1, 14, 14, 30)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 17, 10),
          Time.utc(2006, 1, 17, 16)
        )
      ]
    end
  end

  context "when multiple periods on holidays are encountered" do
    let(:origin) { Time.utc(2006, 1, 14) }

    it "does not include any of those periods" do
      expect(periods.take(3).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 14, 11),
          Time.utc(2006, 1, 14, 14, 30)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 17, 10),
          Time.utc(2006, 1, 17, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 19, 10),
          Time.utc(2006, 1, 19, 16)
        )
      ]
    end
  end

  describe "#timeline" do
    it "returns a timeline" do
      expect(periods.timeline).to be_a Biz::Timeline
    end

    it "configures the timeline to use its periods" do
      expect(periods.timeline.periods).to be periods
    end
  end
end
