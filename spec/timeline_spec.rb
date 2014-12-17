RSpec.describe Biz::Timeline do
  subject(:timeline) { described_class.new(periods) }

  describe "#after" do
    let(:periods) {
      [
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
        )
      ].lazy
    }

    let(:origin) { Time.utc(2006, 1, 2) }

    it "generates a timeline after the provided origin" do
      expect(timeline.after(origin).until(Time.utc(2006, 1, 4)).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 2, 9),
          Time.utc(2006, 1, 2, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 3, 10),
          Time.utc(2006, 1, 3, 16)
        )
      ]
    end
  end

  describe "#before" do
    let(:periods) {
      [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 4, 9),
          Time.utc(2006, 1, 4, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 3, 10),
          Time.utc(2006, 1, 3, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 2, 9),
          Time.utc(2006, 1, 2, 17)
        )
      ].lazy
    }

    let(:origin) { Time.utc(2006, 1, 5) }

    it "generates a timeline before the provided origin" do
      expect(timeline.before(origin).until(Time.utc(2006, 1, 3)).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 4, 9),
          Time.utc(2006, 1, 4, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 3, 10),
          Time.utc(2006, 1, 3, 16)
        )
      ]
    end
  end
end
