require 'rails_helper'

describe 'to_hash' do
  let(:shop) { 
    FactoryBot.create(:shop)
  }
  context 'No relations' do
    example 'All attributes' do
      expect(shop.to_hash).to match({
        id: shop.id,
        name: shop.name,
        created_at: shop.created_at,
        updated_at: shop.updated_at
      })
    end

    example 'Except' do
      expect(shop.to_hash(except: [:created_at])).to match({
        id: shop.id,
        name: shop.name,
        updated_at: shop.updated_at
      })

      expect(shop.to_hash(except: [:updated_at, :created_at])).to match({
        id: shop.id,
        name: shop.name
      })
    end

    example 'Only' do
      expect(shop.to_hash(only: [:name])).to match({
        name: shop.name,
      })

      expect(shop.to_hash(only: [:name, :id])).to match({
        id: shop.id,
        name: shop.name
      })
    end
  end
end