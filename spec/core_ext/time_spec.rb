require 'biz/core_ext/time'

RSpec.describe Biz::CoreExt::Time do
  let(:time_class) { Class.new(Time) do include Biz::CoreExt::Time end }

  before do
    Biz.configure do |config|
      config.hours     = {mon: {'09:00' => '17:00'}}
      config.holidays  = [Date.new(2006, 1, 1)]
      config.time_zone = 'Etc/UTC'
    end
  end

  after { Thread.current[:biz_schedule] = nil }

  describe '#business_hours?' do
    context 'when the time is within a business period' do
      let(:time) { time_class.utc(2006, 1, 2, 10) }

      it 'returns true' do
        expect(time.business_hours?).to eq true
      end
    end

    context 'when the time is not within a business period' do
      let(:time) { time_class.utc(2006, 1, 2, 8) }

      it 'returns false' do
        expect(time.business_hours?).to eq false
      end
    end
  end

  describe '#on_holiday?' do
    context 'when the time is on a holiday' do
      let(:time) { time_class.utc(2006, 1, 1, 12) }

      it 'returns true' do
        expect(time.on_holiday?).to eq true
      end
    end

    context 'when the time is not on a holiday' do
      let(:time) { time_class.utc(2006, 1, 2, 12) }

      it 'returns false' do
        expect(time.on_holiday?).to eq false
      end
    end
  end
end
