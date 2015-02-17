require 'biz/core_ext/date'

RSpec.describe Biz::CoreExt::Date do
  let(:date_class) { Class.new(Date) do include Biz::CoreExt::Date end }

  before do
    Biz.configure do |config|
      config.business_hours  = {mon: {'09:00' => '17:00'}}
      config.holidays        = []
      config.time_zone       = 'Etc/UTC'
    end
  end

  after { Thread.current[:biz_schedule] = nil }

  describe '#business_day?' do
    context 'when the date contains at least one business period' do
      let(:date) { date_class.new(2006, 1, 2) }

      it 'returns true' do
        expect(date.business_day?).to eq true
      end
    end

    context 'when the date does not contain any business periods' do
      let(:date) { date_class.new(2006, 1, 3) }

      it 'returns false' do
        expect(date.business_day?).to eq false
      end
    end
  end
end
