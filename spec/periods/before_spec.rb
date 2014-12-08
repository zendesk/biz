RSpec.describe Biz::Periods::Before do
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

  subject(:periods) { described_class.new(schedule, origin) }

  describe "#until" do
    context "when an endpoint has second precision" do
      let(:origin)   { Time.utc(2006, 1, 9, 18) }
      let(:terminus) { Time.utc(2006, 1, 9, 14, 32, 41) }

      it "returns a period with second precision" do
        expect(periods.until(terminus).to_a).to include(
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 9, 14, 32, 41),
            Time.utc(2006, 1, 9, 17)
          )
        )
      end
    end

    context "when no periods occur in the range" do
      let(:origin)   { Time.utc(2006, 1, 9, 8) }
      let(:terminus) { Time.utc(2006, 1, 8, 0) }

      it "returns no periods" do
        expect(periods.until(terminus).count).to eq 0
      end
    end

    context "when one period occurs in the range" do
      let(:origin)   { Time.utc(2006, 1, 9, 18) }
      let(:terminus) { Time.utc(2006, 1, 8, 0) }

      it "returns the period" do
        expect(periods.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 9, 9),
            Time.utc(2006, 1, 9, 17)
          )
        ]
      end
    end

    context "when multiple periods occur in the range" do
      let(:origin)   { Time.utc(2006, 1, 10, 17) }
      let(:terminus) { Time.utc(2006, 1, 8, 0) }

      it "returns the periods" do
        expect(periods.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 10, 10),
            Time.utc(2006, 1, 10, 16)
          ),
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 9, 9),
            Time.utc(2006, 1, 9, 17)
          )
        ]
      end
    end

    context "when the origin is in the middle of a period" do
      let(:origin)   { Time.utc(2006, 1, 9, 12) }
      let(:terminus) { Time.utc(2006, 1, 8, 0) }

      it "includes only the contained part as a period" do
        expect(periods.until(terminus).to_a).to include(
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 9, 9),
            Time.utc(2006, 1, 9, 12)
          )
        )
      end
    end

    context "when the terminus is in the middle of a period" do
      let(:origin)   { Time.utc(2006, 1, 9, 18) }
      let(:terminus) { Time.utc(2006, 1, 9, 12) }

      it "includes only the contained part as a period" do
        expect(periods.until(terminus).to_a).to include(
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 9, 12),
            Time.utc(2006, 1, 9, 17)
          )
        )
      end
    end

    context "when the range is contained by a period" do
      let(:origin)   { Time.utc(2006, 1, 9, 14) }
      let(:terminus) { Time.utc(2006, 1, 9, 10) }

      it "returns only the contained part of the period" do
        expect(periods.until(terminus).to_a).to include(
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 9, 10),
            Time.utc(2006, 1, 9, 14)
          )
        )
      end
    end

    context "when the endpoints are contained by two different periods" do
      let(:origin)   { Time.utc(2006, 1, 10, 12) }
      let(:terminus) { Time.utc(2006, 1, 9, 14) }

      it "returns the contained parts of the periods" do
        expect(periods.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 10, 10),
            Time.utc(2006, 1, 10, 12)
          ),
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 9, 14),
            Time.utc(2006, 1, 9, 17)
          )
        ]
      end
    end

    context "when the range spans multiple weeks" do
      let(:origin)   { Time.utc(2006, 2, 6, 8) }
      let(:terminus) { Time.utc(2006, 1, 9, 8) }

      it "returns all of the periods" do
        expect(periods.until(terminus).count).to eq 24
      end
    end

    context "when the terminus is after the origin" do
      let(:origin)   { Time.utc(2006, 1, 1, 8) }
      let(:terminus) { Time.utc(2006, 1, 9, 8) }

      it "returns no periods" do
        expect(periods.until(terminus).count).to eq 0
      end
    end

    context "when a holiday contains a period" do
      let(:origin)   { Time.utc(2006, 1, 9, 18) }
      let(:terminus) { Time.utc(2006, 1, 9, 8) }

      let(:holidays) { [Date.new(2006, 1, 9), Date.new(2006, 1, 10)] }

      it "does not include the period" do
        expect(periods.until(terminus).count).to eq 0
      end
    end
  end

  describe "#for" do
    context "when the origin has second precision" do
      let(:origin)   { Time.utc(2006, 1, 9, 11, 32, 42) }
      let(:duration) { Biz::Duration.hours(2) }

      it "returns a period with second precision" do
        expect(periods.for(duration).to_a).to include(
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 9, 9, 32, 42),
            Time.utc(2006, 1, 9, 11, 32, 42)
          )
        )
      end
    end

    context "when the duration has second precision" do
      let(:origin)   { Time.utc(2006, 1, 9, 9, 32, 7) }
      let(:duration) { Biz::Duration.seconds(127) }

      it "returns a period with second precision" do
        expect(periods.for(duration).to_a).to include(
          Biz::TimeSegment.new(
            Time.utc(2006, 1, 9, 9, 30),
            Time.utc(2006, 1, 9, 9, 32, 7)
          )
        )
      end
    end

    context "when the origin is in a period" do
      let(:origin) { Time.utc(2006, 1, 9, 14) }

      context "and the duration is contained in the same period" do
        let(:duration) { Biz::Duration.hours(2) }

        it "includes the correct period" do
          expect(periods.for(duration).to_a).to include(
            Biz::TimeSegment.new(
              Time.utc(2006, 1, 9, 12),
              Time.utc(2006, 1, 9, 14)
            )
          )
        end
      end

      context "and the duration extends to the edge of the period" do
        let(:duration) { Biz::Duration.hours(5) }

        it "includes the correct period" do
          expect(periods.for(duration).to_a).to include(
            Biz::TimeSegment.new(
              Time.utc(2006, 1, 9, 9),
              Time.utc(2006, 1, 9, 14)
            )
          )
        end
      end

      context "and the duration extends beyond the period" do
        let(:duration) { Biz::Duration.hours(8) }

        it "returns the correct periods" do
          expect(periods.for(duration).to_a).to eq [
            Biz::TimeSegment.new(
              Time.utc(2006, 1, 9, 9),
              Time.utc(2006, 1, 9, 14)
            ),
            Biz::TimeSegment.new(
              Time.utc(2006, 1, 7, 11, 30),
              Time.utc(2006, 1, 7, 14, 30)
            )
          ]
        end
      end
    end

    context "when the origin is not in a period" do
      let(:origin) { Time.utc(2006, 1, 9, 18) }

      context "and the duration is shorter than the next period" do
        let(:duration) { Biz::Duration.hours(2) }

        it "returns a part of the next period" do
          expect(periods.for(duration).to_a).to include(
            Biz::TimeSegment.new(
              Time.utc(2006, 1, 9, 15),
              Time.utc(2006, 1, 9, 17)
            )
          )
        end
      end

      context "and the duration is longer than the next period" do
        let(:duration) { Biz::Duration.hours(9) }

        it "includes a part of the following period" do
          expect(periods.for(duration).to_a).to include(
            Biz::TimeSegment.new(
              Time.utc(2006, 1, 7, 13, 30),
              Time.utc(2006, 1, 7, 14, 30)
            )
          )
        end
      end
    end

    context "when the duration spans multiple weeks" do
      let(:origin)   { Time.utc(2006, 1, 9, 8) }
      let(:duration) { Biz::Duration.hours(158) }

      it "returns all of the periods" do
        expect(periods.for(duration).count).to eq 24
      end
    end
  end
end
