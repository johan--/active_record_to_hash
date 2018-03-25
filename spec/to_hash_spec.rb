require 'rails_helper'

describe 'to_hash' do
  let(:shop) { 
    FactoryBot.create(:shop)
  }
  context 'No relations' do
    example 'All attributes' do
      binding.pry
    end
  end
end