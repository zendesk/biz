# frozen_string_literal: true

RSpec.describe Biz::WeekTime do
  describe '.from_time' do
    let(:time) { Time.utc(2006, 1, 9, 9, 30) }

    it 'creates the proper week time' do
      expect(described_class.from_time(time)).to eq(
        described_class.start(week_minute(wday: 1, hour: 9, min: 30))
      )
    end
  end

  describe '.start' do
    let(:week_time) {
      described_class.start(Biz::DayOfWeek.all.first.start_minute)
    }

    it 'creates a week time that acts as a start time' do
      expect(week_time.timestamp).to eq '00:00'
    end
  end

  describe '.end' do
    let(:week_time) { described_class.end(Biz::DayOfWeek.all.first.end_minute) }

    it 'creates a week time that acts as an end time' do
      expect(week_time.timestamp).to eq '24:00'
    end
  end

  describe '.build' do
    let(:week_time) {
      described_class.build(Biz::DayOfWeek.all.first.start_minute)
    }

    it 'creates a week time that acts as a start time' do
      expect(week_time.timestamp).to eq '00:00'
    end
  end
end
