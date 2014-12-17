RSpec.describe Biz::Timeline::Before do
  let(:periods) {
    [
      Biz::TimeSegment.new(Time.utc(2006, 1, 4, 9), Time.utc(2006, 1, 4, 17)),
      Biz::TimeSegment.new(Time.utc(2006, 1, 3, 10), Time.utc(2006, 1, 3, 16)),
      Biz::TimeSegment.new(Time.utc(2006, 1, 2, 9), Time.utc(2006, 1, 2, 17))
    ].lazy
  }

  subject(:timeline) { described_class.new(periods, origin) }

  describe "#until" do
    context "when an endpoint has second precision" do
      let(:origin)   { Time.utc(2006, 1, 4, 18) }
      let(:terminus) { Time.utc(2006, 1, 4, 14, 32, 41) }

      it "returns a period with second precision" do
        expect(timeline.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 4, 14, 32, 41),
            Time.utc(2006, 1, 4, 17)
          )
        ]
      end
    end

    context "when no periods occur in the range" do
      let(:origin)   { Time.utc(2006, 1, 4, 8) }
      let(:terminus) { Time.utc(2006, 1, 3, 17) }

      it "returns no periods" do
        expect(timeline.until(terminus).count).to eq 0
      end
    end

    context "when one period occurs in the range" do
      let(:origin)   { Time.utc(2006, 1, 3, 17) }
      let(:terminus) { Time.utc(2006, 1, 3, 9) }

      it "returns the period" do
        expect(timeline.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 3, 10),
            Time.utc(2006, 1, 3, 16)
          )
        ]
      end
    end

    context "when multiple periods occur in the range" do
      let(:origin)   { Time.utc(2006, 1, 4, 18) }
      let(:terminus) { Time.utc(2006, 1, 3, 8) }

      it "returns the periods" do
        expect(timeline.until(terminus).to_a).to eq [
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

    context "when the origin is in the middle of a period" do
      let(:origin)   { Time.utc(2006, 1, 3, 14) }
      let(:terminus) { Time.utc(2006, 1, 3, 0) }

      it "includes only the contained part as a period" do
        expect(timeline.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 3, 10),
            Time.utc(2006, 1, 3, 14)
          )
        ]
      end
    end

    context "when the terminus is in the middle of a period" do
      let(:origin)   { Time.utc(2006, 1, 4, 18) }
      let(:terminus) { Time.utc(2006, 1, 4, 12) }

      it "includes only the contained part as a period" do
        expect(timeline.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 4, 12),
            Time.utc(2006, 1, 4, 17)
          )
        ]
      end
    end

    context "when the range is contained by a period" do
      let(:origin)   { Time.utc(2006, 1, 4, 14) }
      let(:terminus) { Time.utc(2006, 1, 4, 10) }

      it "returns only the contained part of the period" do
        expect(timeline.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 4, 10),
            Time.utc(2006, 1, 4, 14)
          )
        ]
      end
    end

    context "when the endpoints are contained by two different periods" do
      let(:origin)   { Time.utc(2006, 1, 4, 12) }
      let(:terminus) { Time.utc(2006, 1, 3, 14) }

      it "returns the contained parts of the periods" do
        expect(timeline.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 4, 9),
            Time.utc(2006, 1, 4, 12)
          ),
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 3, 14),
            Time.utc(2006, 1, 3, 16)
          )
        ]
      end
    end

    context "when the terminus is after the origin" do
      let(:origin)   { Time.utc(2006, 1, 2, 8) }
      let(:terminus) { Time.utc(2006, 1, 3, 8) }

      it "returns no periods" do
        expect(timeline.until(terminus).count).to eq 0
      end
    end

    context "when a period begins on the terminus" do
      let(:origin)   { Time.utc(2006, 1, 4, 18) }
      let(:terminus) { Time.utc(2006, 1, 4, 17) }

      it "returns no periods" do
        expect(timeline.until(terminus).count).to eq 0
      end
    end
  end

  describe "#for" do
    context "when the origin has second precision" do
      let(:origin)   { Time.utc(2006, 1, 2, 11, 32, 42) }
      let(:duration) { Biz::Duration.hours(2) }

      it "returns a period with second precision" do
        expect(timeline.for(duration).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 2, 9, 32, 42),
            Time.utc(2006, 1, 2, 11, 32, 42)
          )
        ]
      end
    end

    context "when the duration has second precision" do
      let(:origin)   { Time.utc(2006, 1, 2, 9, 32, 7) }
      let(:duration) { Biz::Duration.seconds(127) }

      it "returns a period with second precision" do
        expect(timeline.for(duration).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 2, 9, 30),
            Time.utc(2006, 1, 2, 9, 32, 7)
          )
        ]
      end
    end

    context "when the origin is in a period" do
      let(:origin) { Time.utc(2006, 1, 4, 14) }

      context "and the duration is contained in the same period" do
        let(:duration) { Biz::Duration.hours(2) }

        it "includes the correct period" do
          expect(timeline.for(duration).to_a).to eq [
            Biz::TimeSegment.new(
              Time.utc(2006, 1, 4, 12),
              Time.utc(2006, 1, 4, 14)
            )
          ]
        end
      end

      context "and the duration extends to the edge of the period" do
        let(:duration) { Biz::Duration.hours(5) }

        it "includes the correct period" do
          expect(timeline.for(duration).to_a).to eq [
            Biz::TimeSegment.new(
              Time.utc(2006, 1, 4, 9),
              Time.utc(2006, 1, 4, 14)
            )
          ]
        end
      end

      context "and the duration extends beyond the period" do
        let(:duration) { Biz::Duration.hours(8) }

        it "returns the correct periods" do
          expect(timeline.for(duration).to_a).to eq [
            Biz::TimeSegment.new(
              Time.utc(2006, 1, 4, 9),
              Time.utc(2006, 1, 4, 14)
            ),
            Biz::TimeSegment.new(
              Time.utc(2006, 1, 3, 13),
              Time.utc(2006, 1, 3, 16)
            )
          ]
        end
      end
    end

    context "when the origin is not in a period" do
      let(:origin) { Time.utc(2006, 1, 4, 18) }

      context "and the duration is shorter than the next period" do
        let(:duration) { Biz::Duration.hours(2) }

        it "returns a part of the next period" do
          expect(timeline.for(duration).to_a).to eq [
            Biz::TimeSegment.new(
              Time.utc(2006, 1, 4, 15),
              Time.utc(2006, 1, 4, 17)
            )
          ]
        end
      end

      context "and the duration is longer than the next period" do
        let(:duration) { Biz::Duration.hours(9) }

        it "includes a part of the following period" do
          expect(timeline.for(duration).to_a).to eq [
            Biz::TimeSegment.new(
              Time.utc(2006, 1, 4, 9),
              Time.utc(2006, 1, 4, 17)
            ),
            Biz::TimeSegment.new(
              Time.utc(2006, 1, 3, 15),
              Time.utc(2006, 1, 3, 16)
            )
          ]
        end
      end
    end
  end
end
