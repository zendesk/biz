require 'helper'

require 'biz/periods/before'
require 'biz/time'

RSpec.describe Biz::Periods::Before do
  let(:work_periods) {
    ->(week) {
      [
        Biz::TimeSegment.new(
          week.to_i * Biz::Time::WEEK + 1 * Biz::Time::DAY +  9 * Biz::Time::HOUR,
          week.to_i * Biz::Time::WEEK + 1 * Biz::Time::DAY + 17 * Biz::Time::HOUR
        ),
        Biz::TimeSegment.new(
          week.to_i * Biz::Time::WEEK + 2 * Biz::Time::DAY + 10 * Biz::Time::HOUR,
          week.to_i * Biz::Time::WEEK + 2 * Biz::Time::DAY + 16 * Biz::Time::HOUR
        ),
        Biz::TimeSegment.new(
          week.to_i * Biz::Time::WEEK + 3 * Biz::Time::DAY +  9 * Biz::Time::HOUR,
          week.to_i * Biz::Time::WEEK + 3 * Biz::Time::DAY + 17 * Biz::Time::HOUR
        ),
        Biz::TimeSegment.new(
          week.to_i * Biz::Time::WEEK + 4 * Biz::Time::DAY + 10 * Biz::Time::HOUR,
          week.to_i * Biz::Time::WEEK + 4 * Biz::Time::DAY + 16 * Biz::Time::HOUR
        ),
        Biz::TimeSegment.new(
          week.to_i * Biz::Time::WEEK + 5 * Biz::Time::DAY +  9 * Biz::Time::HOUR,
          week.to_i * Biz::Time::WEEK + 5 * Biz::Time::DAY + 17 * Biz::Time::HOUR
        ),
        Biz::TimeSegment.new(
          week.to_i * Biz::Time::WEEK + 6 * Biz::Time::DAY + 11   * Biz::Time::HOUR,
          week.to_i * Biz::Time::WEEK + 6 * Biz::Time::DAY + 14.5 * Biz::Time::HOUR
        )
      ]
    }
  }
  let(:holidays) { ->(week) { [] } }

  subject(:periods) {
    described_class.new(origin, work_periods: work_periods, holidays: holidays)
  }

  describe "#until" do
    context "when an endpoint has second precision" do
      let(:origin)   { Time.utc(1970, 1, 9, 18) }
      let(:terminus) { Time.utc(1970, 1, 9, 14, 32, 41) }

      it "returns a period with second precision" do
        expect(periods.until(terminus).to_a).to include(
          Biz::TimeSegment.new(
            Time.utc(1970, 1, 9, 14, 32, 41),
            Time.utc(1970, 1, 9, 17)
          )
        )
      end
    end

    context "when no periods occur in the range" do
      let(:origin)   { Time.utc(1970, 1, 9, 8) }
      let(:terminus) { Time.utc(1970, 1, 8, 0) }

      it "returns no periods" do
        expect(periods.until(terminus).count).to eq 0
      end
    end

    context "when one period occurs in the range" do
      let(:origin)   { Time.utc(1970, 1, 9, 18) }
      let(:terminus) { Time.utc(1970, 1, 8, 0) }

      it "returns the period" do
        expect(periods.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(1970, 1, 9, 9),
            Time.utc(1970, 1, 9, 17)
          )
        ]
      end
    end

    context "when multiple periods occur in the range" do
      let(:origin)   { Time.utc(1970, 1, 10, 17) }
      let(:terminus) { Time.utc(1970, 1, 8, 0) }

      it "returns the periods" do
        expect(periods.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(1970, 1, 10, 10),
            Time.utc(1970, 1, 10, 16)
          ),
          Biz::TimeSegment.new(
            Time.utc(1970, 1, 9, 9),
            Time.utc(1970, 1, 9, 17)
          )
        ]
      end
    end

    context "when the origin is in the middle of a period" do
      let(:origin)   { Time.utc(1970, 1, 9, 12) }
      let(:terminus) { Time.utc(1970, 1, 8, 0) }

      it "includes only the contained part as a period" do
        expect(periods.until(terminus).to_a).to include(
          Biz::TimeSegment.new(
            Time.utc(1970, 1, 9, 9),
            Time.utc(1970, 1, 9, 12)
          )
        )
      end
    end

    context "when the terminus is in the middle of a period" do
      let(:origin)   { Time.utc(1970, 1, 9, 18) }
      let(:terminus) { Time.utc(1970, 1, 9, 12) }

      it "includes only the contained part as a period" do
        expect(periods.until(terminus).to_a).to include(
          Biz::TimeSegment.new(
            Time.utc(1970, 1, 9, 12),
            Time.utc(1970, 1, 9, 17)
          )
        )
      end
    end

    context "when the range is contained by a period" do
      let(:origin)   { Time.utc(1970, 1, 9, 14) }
      let(:terminus) { Time.utc(1970, 1, 9, 10) }

      it "returns only the contained part of the period" do
        expect(periods.until(terminus).to_a).to include(
          Biz::TimeSegment.new(
            Time.utc(1970, 1, 9, 10),
            Time.utc(1970, 1, 9, 14)
          )
        )
      end
    end

    context "when the endpoints are contained by two different periods" do
      let(:origin)   { Time.utc(1970, 1, 10, 12) }
      let(:terminus) { Time.utc(1970, 1, 9, 14) }

      it "returns the contained parts of the periods" do
        expect(periods.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(1970, 1, 10, 10),
            Time.utc(1970, 1, 10, 12)
          ),
          Biz::TimeSegment.new(
            Time.utc(1970, 1, 9, 14),
            Time.utc(1970, 1, 9, 17)
          )
        ]
      end
    end

    context "when the range spans multiple weeks" do
      let(:origin)   { Time.utc(1970, 2, 6, 8) }
      let(:terminus) { Time.utc(1970, 1, 9, 8) }

      it "returns all of the periods" do
        expect(periods.until(terminus).count).to eq 24
      end
    end

    context "when the terminus is after the origin" do
      let(:origin)   { Time.utc(1970, 1, 1, 8) }
      let(:terminus) { Time.utc(1970, 1, 9, 8) }

      it "returns no periods" do
        expect(periods.until(terminus).count).to eq 0
      end
    end

    context "when a holiday contains a period" do
      let(:origin)   { Time.utc(1970, 1, 9, 18) }
      let(:terminus) { Time.utc(1970, 1, 9, 8) }

      let(:holidays) {
        ->(week) {
          [Biz::TimeSegment.new(Time.utc(1970, 1, 9), Time.utc(1970, 1, 10))]
        }
      }

      it "does not include the period" do
        expect(periods.until(terminus).count).to eq 0
      end
    end

    context "when a holiday partially contains a period" do
      let(:origin)   { Time.utc(1970, 1, 2, 6) }
      let(:terminus) { Time.utc(1970, 1, 1, 18) }

      let(:work_periods) {
        ->(week) {
          [
            Biz::TimeSegment.new(
              week.to_i * Biz::Time::WEEK + 0 * Biz::Time::DAY + 20 * Biz::Time::HOUR,
              week.to_i * Biz::Time::WEEK + 1 * Biz::Time::DAY +  4 * Biz::Time::HOUR
            )
          ]
        }
      }
      let(:holidays) {
        ->(week) {
          [Biz::TimeSegment.new(Time.utc(1970, 1, 2), Time.utc(1970, 1, 3))]
        }
      }

      it "does not include the contained part of the interval" do
        expect(periods.until(terminus).to_a).to include(
          Biz::TimeSegment.new(
            Time.utc(1970, 1, 1, 20),
            Time.utc(1970, 1, 2, 0)
          )
        )
      end
    end
  end

  describe "#for" do
    context "when the origin has second precision" do
      let(:origin)   { Time.utc(1970, 1, 9, 11, 32, 42) }
      let(:duration) { Biz::Duration.hours(2) }

      it "returns a period with second precision" do
        expect(periods.for(duration).to_a).to include(
          Biz::TimeSegment.new(
            Time.utc(1970, 1, 9, 9, 32, 42),
            Time.utc(1970, 1, 9, 11, 32, 42)
          )
        )
      end
    end

    context "when the duration has second precision" do
      let(:origin)   { Time.utc(1970, 1, 9, 9, 32, 7) }
      let(:duration) { Biz::Duration.seconds(127) }

      it "returns a period with second precision" do
        expect(periods.for(duration).to_a).to include(
          Biz::TimeSegment.new(
            Time.utc(1970, 1, 9, 9, 30),
            Time.utc(1970, 1, 9, 9, 32, 7)
          )
        )
      end
    end

    context "when the origin is in a period" do
      let(:origin) { Time.utc(1970, 1, 9, 14) }

      context "and the duration is contained in the same period" do
        let(:duration) { Biz::Duration.hours(2) }

        it "includes the correct period" do
          expect(periods.for(duration).to_a).to include(
            Biz::TimeSegment.new(
              Time.utc(1970, 1, 9, 12),
              Time.utc(1970, 1, 9, 14)
            )
          )
        end
      end

      context "and the duration extends to the edge of the period" do
        let(:duration) { Biz::Duration.hours(5) }

        it "includes the correct period" do
          expect(periods.for(duration).to_a).to include(
            Biz::TimeSegment.new(
              Time.utc(1970, 1, 9, 9),
              Time.utc(1970, 1, 9, 14)
            )
          )
        end
      end

      context "and the duration extends beyond the period" do
        let(:duration) { Biz::Duration.hours(8) }

        it "returns the correct periods" do
          expect(periods.for(duration).to_a).to eq [
            Biz::TimeSegment.new(
              Time.utc(1970, 1, 9, 9),
              Time.utc(1970, 1, 9, 14)
            ),
            Biz::TimeSegment.new(
              Time.utc(1970, 1, 7, 11, 30),
              Time.utc(1970, 1, 7, 14, 30)
            )
          ]
        end
      end
    end

    context "when the origin is not in a period" do
      let(:origin) { Time.utc(1970, 1, 9, 18) }

      context "and the duration is shorter than the next period" do
        let(:duration) { Biz::Duration.hours(2) }

        it "returns a part of the next period" do
          expect(periods.for(duration).to_a).to include(
            Biz::TimeSegment.new(
              Time.utc(1970, 1, 9, 15),
              Time.utc(1970, 1, 9, 17)
            )
          )
        end
      end

      context "and the duration is longer than the next period" do
        let(:duration) { Biz::Duration.hours(9) }

        it "includes a part of the following period" do
          expect(periods.for(duration).to_a).to include(
            Biz::TimeSegment.new(
              Time.utc(1970, 1, 7, 13, 30),
              Time.utc(1970, 1, 7, 14, 30)
            )
          )
        end
      end
    end

    context "when the duration spans multiple weeks" do
      let(:origin)   { Time.utc(1970, 1, 9, 8) }
      let(:duration) { Biz::Duration.hours(158) }

      it "returns all of the periods" do
        expect(periods.for(duration).count).to eq 24
      end
    end
  end
end
