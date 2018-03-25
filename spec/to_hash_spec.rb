require 'rails_helper'

describe 'to_hash' do
  let(:shop) { 
    FactoryBot.create(:shop)
  }
  context 'No relations' do
    example 'All attributes' do
      expect(shop.to_hash).to match(shop.attributes)
    end
  end
end