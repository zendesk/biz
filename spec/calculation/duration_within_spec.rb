# frozen_string_literal: true

RSpec.describe Biz::Calculation::DurationWithin do
  subject(:calculation) {
    described_class.new(schedule, calculation_period)
  }

  context 'when the calculation start time is after the end time' do
    let(:calculation_period) {
      Biz::TimeSegment.new(Time.utc(2006, 1, 8), Time.utc(2006, 1, 1))
    }

    it 'returns a zero duration' do
      expect(calculation).to eq Biz::Duration.new(0)
    end
  end

  context 'when the calculation start time is equal to the end time' do
    let(:calculation_period) {
      Biz::TimeSegment.new(Time.utc(2006, 1, 1), Time.utc(2006, 1, 1))
    }

    it 'returns a zero duration' do
      expect(calculation).to eq Biz::Duration.new(0)
    end
  end

  context 'when the calculation start time is before the end time' do
    let(:calculation_period) {
      Biz::TimeSegment.new(Time.utc(2006, 1, 1), Time.utc(2006, 1, 8))
    }

    it 'returns the elapsed duration' do
      expect(calculation).to eq Biz::Duration.hours(39.5)
    end
  end
end
