RSpec.describe Biz::Validation do
  let(:raw) { Struct.new(:hours, :holidays, :time_zone).new }

  subject(:validation) { described_class.new(raw) }

  describe '.perform' do
    before do raw.hours = {} end

    it 'performs the validation on the provided raw input' do
      expect { described_class.perform(raw) }.to raise_error(
        Biz::Error::Configuration
      )
    end
  end

  describe '#perform' do
    describe 'when the hours are hash-like' do
      describe 'and the hours are not empty' do
        before do raw.hours = {mon: {'09:00' => '17:00'}} end

        it 'does not raise an error' do
          expect { validation.perform }.not_to raise_error
        end
      end

      describe 'and the hours are empty' do
        before do raw.hours = {} end

        it 'raises a configuration error' do
          expect { validation.perform }.to raise_error Biz::Error::Configuration
        end
      end
    end

    describe 'when the hours are not hash-like' do
      before do raw.hours = 1 end

      it 'raises a configuration error' do
        expect { validation.perform }.to raise_error Biz::Error::Configuration
      end
    end
  end
end
