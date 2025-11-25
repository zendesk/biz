# frozen_string_literal: true

RSpec.describe Biz::Periods::Proxy do
  let(:hours) {
    {
      mon: {'09:00' => '17:00'},
      tue: {'10:00' => '16:00'},
      wed: {'09:00' => '17:00'},
      thu: {'10:00' => '12:00', '13:00' => '17:00'},
      fri: {'09:00' => '17:00'},
      sat: {'11:00' => '14:30'}
    }
  }

  subject(:periods) { described_class.new(schedule(hours:))) }

  describe '#after' do
    let(:origin) { Time.utc(2006, 1, 3) }

    it 'generates periods after the provided origin' do
      expect(periods.after(origin).take(2).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 3, 10),
          Time.utc(2006, 1, 3, 16)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 4, 9),
          Time.utc(2006, 1, 4, 17)
        )
      ]
    end
  end

  describe '#before' do
    let(:origin) { Time.utc(2006, 1, 5) }

    it 'generates periods before the provided origin' do
      expect(periods.before(origin).take(2).to_a).to eq [
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

  describe '#on' do
    let(:date) { Date.new(2006, 1, 5) }

    it 'generates periods on the provided date' do
      expect(periods.on(date).to_a).to eq [
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 5, 10),
          Time.utc(2006, 1, 5, 12)
        ),
        Biz::TimeSegment.new(
          Time.utc(2006, 1, 5, 13),
          Time.utc(2006, 1, 5, 17)
        )
      ]
    end
  end
end
