require 'helper'

require 'biz/date'

RSpec.describe Biz::Date do
  describe ".from_day" do
    let(:built_date) { described_class.from_day(960) }

    it "builds a date with the correct year" do
      expect(built_date.year).to eq 1972
    end

    it "builds a date with the correct month" do
      expect(built_date.month).to eq 8
    end

    it "builds a date with the correct day" do
      expect(built_date.mday).to eq 18
    end

    it "returns a Date object" do
      expect(built_date).to be_instance_of Date
    end
  end
end
