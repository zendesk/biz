RSpec.describe Biz::WeekTime do
  describe '.start' do
    let(:week_time) {
      described_class.start(Biz::DayOfWeek::MONDAY.start_minute)
    }

    it 'creates a week time that acts as a start time' do
      expect(week_time.timestamp).to eq '00:00'
    end
  end

  describe '.end' do
    let(:week_time) { described_class.end(Biz::DayOfWeek::MONDAY.end_minute) }

    it 'creates a week time that acts as an end time' do
      expect(week_time.timestamp).to eq '24:00'
    end
  end

  describe '.build' do
    let(:week_time) {
      described_class.build(Biz::DayOfWeek::MONDAY.start_minute)
    }

    it 'creates a week time that acts as a start time' do
      expect(week_time.timestamp).to eq '00:00'
    end
  end
end
