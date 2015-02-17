require 'biz/core_ext/fixnum'

RSpec.describe Biz::CoreExt::Fixnum do
  let(:fixnum_class) {
    Class.new(SimpleDelegator) do include Biz::CoreExt::Fixnum end
  }

  before do
    Biz.configure do |config|
      config.business_hours  = {mon: {'09:00' => '17:00'}}
      config.holidays        = []
      config.time_zone       = 'Etc/UTC'
    end
  end

  after { Thread.current[:biz_schedule] = nil }

  describe '#business_second' do
    it 'performs a for-duration calculation for the given number of seconds' do
      expect(
        fixnum_class.new(1).business_second.after(Time.utc(2006, 1, 2, 10))
      ).to eq Time.utc(2006, 1, 2, 10, 0, 1)
    end
  end

  describe '#business_seconds' do
    it 'performs a for-duration calculation for the given number of seconds' do
      expect(
        fixnum_class.new(10).business_seconds.after(Time.utc(2006, 1, 2, 10))
      ).to eq Time.utc(2006, 1, 2, 10, 0, 10)
    end
  end

  describe '#business_minute' do
    it 'performs a for-duration calculation for the given number of minutes' do
      expect(
        fixnum_class.new(1).business_minute.after(Time.utc(2006, 1, 2, 10))
      ).to eq Time.utc(2006, 1, 2, 10, 1)
    end
  end

  describe '#business_minutes' do
    it 'performs a for-duration calculation for the given number of minutes' do
      expect(
        fixnum_class.new(10).business_minutes.after(Time.utc(2006, 1, 2, 10))
      ).to eq Time.utc(2006, 1, 2, 10, 10)
    end
  end

  describe '#business_hour' do
    it 'performs a for-duration calculation for the given number of hours' do
      expect(
        fixnum_class.new(1).business_hour.after(Time.utc(2006, 1, 2, 10))
      ).to eq Time.utc(2006, 1, 2, 11)
    end
  end

  describe '#business_hours' do
    it 'performs a for-duration calculation for the given number of hours' do
      expect(
        fixnum_class.new(10).business_hours.after(Time.utc(2006, 1, 2, 10))
      ).to eq Time.utc(2006, 1, 9, 12)
    end
  end
end
