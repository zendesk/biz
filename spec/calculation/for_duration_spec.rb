RSpec.describe Biz::Calculation::ForDuration do
  subject(:calculation) { described_class.new(schedule.periods, duration) }

  context 'when initializing' do
    context 'with a positive duration' do
      it 'is successful' do
        expect(described_class.new([], Biz::Duration.hour(1)).duration).to eq(
          Biz::Duration.hour(1)
        )
      end
    end

    context 'with a negative duration' do
      it 'fails hard' do
        expect {
          described_class.new([], Biz::Duration.hour(-1))
        }.to raise_error ArgumentError
      end
    end

    context 'with a zero duration' do
      it 'fails hard' do
        expect {
          described_class.new([], Biz::Duration.hour(0))
        }.to raise_error ArgumentError
      end
    end
  end

  describe '#before' do
    let(:duration) { Biz::Duration.hours(19) }
    let(:time)     { Time.utc(2006, 1, 4, 16) }

    it 'returns the backward time after the elapsed duration' do
      expect(calculation.before(time)).to eq Time.utc(2006, 1, 2, 11)
    end
  end

  describe '#after' do
    let(:duration) { Biz::Duration.hours(19) }
    let(:time)     { Time.utc(2006, 1, 2, 11) }

    it 'returns the forward time after the elapsed duration' do
      expect(calculation.after(time)).to eq Time.utc(2006, 1, 4, 16)
    end
  end
end
