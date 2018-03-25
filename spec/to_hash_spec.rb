require 'rails_helper'

describe 'to_hash' do
  let(:shop) { 
    FactoryBot.create(:shop)
  }
  let(:area) { 
    FactoryBot.create(:area)
  }
  context 'No relations' do
    example 'No option' do
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

  context 'With relations' do
    context 'Single record' do
      example 'No option' do
        hash = area.to_hash(with_wide_area: true)
        expect(hash[:wide_area]).to match({
          id: area.wide_area.id,
          name: area.wide_area.name,
          created_at: area.wide_area.created_at,
          updated_at: area.wide_area.updated_at
        })
      end

      example 'Except' do
        hash = area.to_hash(with_wide_area: {except: [:created_at]})
        expect(hash[:wide_area]).to match({
          id: area.wide_area.id,
          name: area.wide_area.name,
          updated_at: area.wide_area.updated_at
        })

        hash = area.to_hash(with_wide_area: {except: [:created_at, :updated_at]})
        expect(hash[:wide_area]).to match({
          id: area.wide_area.id,
          name: area.wide_area.name,
        })
      end

      example 'Only' do
        hash = area.to_hash(with_wide_area: {only: [:name]})
        expect(hash[:wide_area]).to match({
          name: area.wide_area.name,
        })

        hash = area.to_hash(with_wide_area: {only: [:id, :name]})
        expect(hash[:wide_area]).to match({
          id: area.wide_area.id,
          name: area.wide_area.name,
        })
      end

      example 'Key' do
        hash = area.to_hash(with_wide_area: {key: :foobar})
        expect(hash[:wide_area]).to be nil
        expect(hash[:foobar]).to match({
          id: area.wide_area.id,
          name: area.wide_area.name,
          created_at: area.wide_area.created_at,
          updated_at: area.wide_area.updated_at
        })
      end
    end
  end
end