RSpec.describe Biz::Periods do
  subject(:periods) { described_class.new(schedule) }

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
end
