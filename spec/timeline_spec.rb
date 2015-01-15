RSpec.describe Biz::Timeline do
  subject(:timeline) { described_class.new(periods) }

  describe '#forward' do
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

    it 'generates a forward-moving timeline' do
      expect(timeline.forward.until(Time.utc(2006, 1, 4)).to_a).to eq [
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

  describe '#before' do
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

    it 'generates a backward-moving timeline' do
      expect(timeline.backward.until(Time.utc(2006, 1, 3)).to_a).to eq [
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
