RSpec.describe Biz::Holiday do
  let(:date)      { Date.new(2010, 7, 15) }
  let(:time_zone) { TZInfo::Timezone.get('America/Los_Angeles') }

  subject(:holiday) { described_class.new(date, time_zone) }

  describe '#to_time_segment' do
    it 'returns the appropriate time segment' do
      expect(holiday.to_time_segment).to eq(
        Biz::TimeSegment.new(
          in_zone('America/Los_Angeles') { Time.utc(2010, 7, 15) },
          in_zone('America/Los_Angeles') { Time.utc(2010, 7, 16) }
        )
      )
    end
  end
end
