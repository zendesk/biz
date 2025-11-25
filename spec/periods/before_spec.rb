# frozen_string_literal: true

RSpec.describe Biz::Periods::Before do
  let(:hours) {
    {
      mon: {'09:00' => '17:00'},
      tue: {'10:00' => '16:00'},
      wed: {'09:00' => '17:00'},
      thu: {'10:00' => '16:00'},
      fri: {'09:00' => '17:00'},
      sat: {'11:00' => '14:30'}
    }
  }

  let(:shifts) {
    {
      Date.new(2006, 1, 4)  => {'09:00' => '10:00'},
      Date.new(2006, 1, 5)  => {'08:00' => '12:00'},
      Date.new(2006, 1, 31) => {'06:00' => '20:00'}
    }
  }

  let(:breaks)    { {} }
  let(:holidays)  { [Date.new(2006, 1, 16), Date.new(2006, 1, 18)] }
  let(:time_zone) { 'Etc/UTC' }
  let(:origin)    { Time.utc(2006, 1, 8) }

  subject(:periods) {
    described_class.new(
      schedule(hours:,
        shifts:,
        breaks:,
        holidays:,
        time_zone:)
      ),
      origin
    )
  }

  context 'when one week of periods is requested' do
    let(:origin) { Time.utc(2006, 1, 8) }

    it 'returns the proper intervals' do
      expect(periods.take(6).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 11),
          Time.utc(2006, 1, 7, 14, 30)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 6, 9),
          Time.utc(2006, 1, 6, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 5, 8),
          Time.utc(2006, 1, 5, 12)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 4, 9),
          Time.utc(2006, 1, 4, 10)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 3, 10),
          Time.utc(2006, 1, 3, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 2, 9),
          Time.utc(2006, 1, 2, 17)
        )
      ]
    end
  end

  context 'when multiple weeks of periods are requested' do
    let(:origin) { Time.utc(2006, 1, 15) }

    it 'returns the proper intervals' do
      expect(periods.take(12).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 14, 11),
          Time.utc(2006, 1, 14, 14, 30)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 13, 9),
          Time.utc(2006, 1, 13, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 12, 10),
          Time.utc(2006, 1, 12, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 11, 9),
          Time.utc(2006, 1, 11, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 10, 10),
          Time.utc(2006, 1, 10, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 9, 9),
          Time.utc(2006, 1, 9, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 11),
          Time.utc(2006, 1, 7, 14, 30)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 6, 9),
          Time.utc(2006, 1, 6, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 5, 8),
          Time.utc(2006, 1, 5, 12)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 4, 9),
          Time.utc(2006, 1, 4, 10)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 3, 10),
          Time.utc(2006, 1, 3, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 2, 9),
          Time.utc(2006, 1, 2, 17)
        )
      ]
    end
  end

  context 'when the origin is outside a period' do
    let(:origin) { Time.utc(2006, 1, 3) }

    it 'returns a full period first' do
      expect(periods.first).to eq(
        Biz::TimeSegment.new(Time.utc(2006, 1, 2, 9), Time.utc(2006, 1, 2, 17))
      )
    end
  end

  context 'when the origin is inside a period' do
    let(:origin) { Time.utc(2006, 1, 2, 12) }

    it 'returns a partial period first' do
      expect(periods.first).to eq(
        Biz::TimeSegment.new(Time.utc(2006, 1, 2, 9), Time.utc(2006, 1, 2, 12))
      )
    end
  end

  context 'when a break overlaps with the beginning of a period' do
    let(:breaks) { {Date.new(2006, 1, 7) => {'14:00' => '15:00'}} }

    it 'excludes the overlapping time' do
      expect(periods.first).to eq(
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 11),
          Time.utc(2006, 1, 7, 14)
        )
      )
    end
  end

  context 'when a break overlaps with the end of a period' do
    let(:breaks) { {Date.new(2006, 1, 7) => {'10:00' => '12:00'}} }

    it 'excludes the overlapping time' do
      expect(periods.first).to eq(
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 12),
          Time.utc(2006, 1, 7, 14, 30)
        )
      )
    end
  end

  context 'when a break overlaps an entire period' do
    let(:breaks) { {Date.new(2006, 1, 7) => {'10:00' => '16:00'}} }

    it 'excludes that period' do
      expect(periods.first).to eq(
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 6, 9),
          Time.utc(2006, 1, 6, 17)
        )
      )
    end
  end

  context 'when a break is in the middle of a period' do
    let(:breaks) { {Date.new(2006, 1, 7) => {'12:00' => '13:00'}} }

    it 'excludes the overlapping time' do
      expect(periods.take(2).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 13),
          Time.utc(2006, 1, 7, 14, 30)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 11),
          Time.utc(2006, 1, 7, 12)
        )
      ]
    end
  end

  context 'when multiple breaks are in the middle of a period' do
    let(:breaks) {
      {Date.new(2006, 1, 7) => {'11:30' => '12:00', '12:30' => '13:00'}}
    }

    it 'excludes the overlapping time' do
      expect(periods.take(3).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 13),
          Time.utc(2006, 1, 7, 14, 30)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 12),
          Time.utc(2006, 1, 7, 12, 30)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 11),
          Time.utc(2006, 1, 7, 11, 30)
        )
      ]
    end
  end

  context 'when a break overlaps multiple periods' do
    let(:hours)  { {sat: {'17:00' => '19:00', '20:00' => '22:00'}} }
    let(:breaks) { {Date.new(2006, 1, 7) => {'18:00' => '21:00'}} }

    it 'excludes the overlapping time' do
      expect(periods.take(2).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 21),
          Time.utc(2006, 1, 7, 22)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 17),
          Time.utc(2006, 1, 7, 18)
        )
      ]
    end
  end

  context 'when multiple breaks overlap multiple periods' do
    let(:breaks) {
      {
        Date.new(2006, 1, 6) => {'09:30' => '10:15', '11:30' => '12:30'},
        Date.new(2006, 1, 7) => {'12:00' => '13:00', '14:25' => '14:40'}
      }
    }

    it 'excludes the overlapping time' do
      expect(periods.take(5).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 13),
          Time.utc(2006, 1, 7, 14, 25)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 7, 11),
          Time.utc(2006, 1, 7, 12)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 6, 12, 30),
          Time.utc(2006, 1, 6, 17)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 6, 10, 15),
          Time.utc(2006, 1, 6, 11, 30)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 6, 9),
          Time.utc(2006, 1, 6, 9, 30)
        )
      ]
    end
  end

  context 'when a period during a holiday is encountered' do
    let(:origin) { Time.utc(2006, 1, 18) }

    it 'does not include that period' do
      expect(periods.take(2).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 17, 10),
          Time.utc(2006, 1, 17, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 14, 11),
          Time.utc(2006, 1, 14, 14, 30)
        )
      ]
    end
  end

  context 'when multiple periods during holidays are encountered' do
    let(:origin) { Time.utc(2006, 1, 20) }

    it 'does not include any of those periods' do
      expect(periods.take(3).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 19, 10),
          Time.utc(2006, 1, 19, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 17, 10),
          Time.utc(2006, 1, 17, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 14, 11),
          Time.utc(2006, 1, 14, 14, 30)
        )
      ]
    end
  end

  context 'when the origin is near the end of the week' do
    let(:hours)     { {sun: {'06:00' => '18:00'}} }
    let(:time_zone) { 'Asia/Brunei' }

    let(:origin) { in_zone('Asia/Brunei') { Time.utc(2006, 1, 8, 7) } }

    it 'includes the relevant interval from the prior week' do
      expect(periods.first).to eq(
        Biz::TimeSegment.new(
          in_zone('Asia/Brunei') { Time.utc(2006, 1, 8, 6) },
          in_zone('Asia/Brunei') { Time.utc(2006, 1, 8, 7) }
        )
      )
    end
  end

  describe '#timeline' do
    let(:origin) { Time.utc(2006, 1, 4) }

    it 'creates a timeline using its periods' do
      expect(
        periods.timeline.until(Time.utc(2006, 1, 1)).to_a
      ).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 3, 10),
          Time.utc(2006, 1, 3, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 2, 9),
          Time.utc(2006, 1, 2, 17)
        )
      ]
    end
  end
end
