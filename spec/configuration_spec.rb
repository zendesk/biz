RSpec.describe Biz::Configuration do
  subject(:configuration) { described_class.new }

  context "when initialized with a block" do
    subject(:configuration) {
      described_class.new do |config| config.work_hours = 'from block' end
    }

    it "yields itself for configuration" do
      expect(configuration.work_hours).to eq 'from block'
    end
  end

  describe "#work_hours" do
    before { configuration.work_hours = 'work hours' }

    it "returns the configured work hours" do
      expect(configuration.work_hours).to eq 'work hours'
    end
  end

  describe "#holidays" do
    before { configuration.holidays = 'holidays' }

    it "returns the configured holidays" do
      expect(configuration.holidays).to eq 'holidays'
    end
  end

  describe "#time_zone" do
    before { configuration.time_zone = 'time zone' }

    it "returns the configured time zone" do
      expect(configuration.time_zone).to eq 'time zone'
    end
  end
end
