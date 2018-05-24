# frozen_string_literal: true

RSpec.describe Biz::Dates do
  subject(:dates) {
    described_class.new(
      schedule(
        hours:    {mon: {'01:00' => '02:00'}},
        holidays: [Date.new(2006, 1, 9)]
      )
    )
  }

  it 'returns dates based on the configured schedule' do
    expect(dates.after(Date.new(2006, 1, 1)).take(2).to_a).to eq [
      Date.new(2006, 1, 2),
      Date.new(2006, 1, 16)
    ]
  end
end
