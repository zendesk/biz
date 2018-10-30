# frozen_string_literal: true

RSpec.describe Biz::Validation do
  let(:configuration) {
    Biz::Configuration.new do |config| config.hours = hours end
  }

  subject(:validation) { described_class.new(configuration) }

  describe '.perform' do
    let(:hours) { {} }

    it 'performs the validation on the provided configuration' do
      expect {
        described_class.perform(configuration)
      }.to raise_error Biz::Error::Configuration
    end
  end

  describe '#perform' do
    context 'when hours are provided' do
      let(:hours) { {mon: {'09:00' => '17:00'}} }

      it 'does not raise an error' do
        expect { validation.perform }.not_to raise_error
      end
    end

    context 'when hours are not provided' do
      let(:hours) { {} }

      it 'raises a configuration error' do
        expect { validation.perform }.to raise_error Biz::Error::Configuration
      end
    end

    context 'when nonsensical hours are provided' do
      let(:hours) { {mon: {'09:00' => '09:00'}} }

      it 'raises a configuration error' do
        expect { validation.perform }.to raise_error Biz::Error::Configuration
      end
    end

    context 'when a day with no hours is provided' do
      let(:hours) { {mon: {}} }

      it 'raises a configuration error' do
        expect { validation.perform }.to raise_error Biz::Error::Configuration
      end
    end
  end
end
