# frozen_string_literal: true

RSpec.describe Biz::Error do
  it 'is a standard error' do
    expect(described_class.new.is_a?(StandardError)).to eq true
  end

  describe Biz::Error::Configuration do
    it "is a 'biz' error" do
      expect(described_class.new.is_a?(Biz::Error)).to eq true
    end
  end
end
