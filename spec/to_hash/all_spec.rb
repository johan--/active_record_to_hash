require 'rails_helper'

describe 'to_hash' do
  let(:shop) do
    FactoryBot.create(:shop)
  end
  let(:area) do
    FactoryBot.create(:area)
  end
  context 'No relations' do
    example 'No option' do
      expect(shop.to_hash).to match(
        id: shop.id,
        name: shop.name,
        created_at: shop.created_at,
        updated_at: shop.updated_at,
        category_id: shop.category_id
      )
    end

    example 'Except' do
      expect(shop.to_hash(except: :created_at)).to match(
        id: shop.id,
        name: shop.name,
        updated_at: shop.updated_at,
        category_id: shop.category_id
      )

      expect(shop.to_hash(except: %i[updated_at created_at])).to match(
        id: shop.id,
        name: shop.name,
        category_id: shop.category_id
      )
    end

    example 'Only' do
      expect(shop.to_hash(only: :name)).to match(
        name: shop.name
      )

      expect(shop.to_hash(only: %i[name id])).to match(
        id: shop.id,
        name: shop.name
      )
    end
  end

  context 'With relations' do
    context 'Single record' do
      example 'No option' do
        hash = area.to_hash(with_wide_area: true)
        expect(hash[:wide_area]).to match(
          id: area.wide_area.id,
          name: area.wide_area.name,
          created_at: area.wide_area.created_at,
          updated_at: area.wide_area.updated_at
        )
      end

      example 'Except' do
        hash = area.to_hash(with_wide_area: { except: :created_at })
        expect(hash[:wide_area]).to match(
          id: area.wide_area.id,
          name: area.wide_area.name,
          updated_at: area.wide_area.updated_at
        )

        hash = area.to_hash(with_wide_area: { except: %i[created_at updated_at] })
        expect(hash[:wide_area]).to match(
          id: area.wide_area.id,
          name: area.wide_area.name
        )
      end

      example 'Only' do
        hash = area.to_hash(with_wide_area: { only: :name })
        expect(hash[:wide_area]).to match(
          name: area.wide_area.name
        )

        hash = area.to_hash(with_wide_area: { only: %i[id name] })
        expect(hash[:wide_area]).to match(
          id: area.wide_area.id,
          name: area.wide_area.name
        )
      end

      example 'Key' do
        hash = area.to_hash(with_wide_area: { key: :foobar })
        expect(hash[:wide_area]).to be nil
        expect(hash[:foobar]).to match(
          id: area.wide_area.id,
          name: area.wide_area.name,
          created_at: area.wide_area.created_at,
          updated_at: area.wide_area.updated_at
        )
      end
    end

    context 'Multiple records' do
      example 'No option' do
        hash = shop.to_hash(with_areas: true)
        expect(hash[:areas].length).to eq shop.areas.count
        shop.areas.each.with_index do |area, index|
          expect(hash[:areas][index]).to match(
            id: area.id,
            name: area.name,
            wide_area_id: area.wide_area_id,
            created_at: area.created_at,
            updated_at: area.updated_at
          )
        end
      end

      example 'Except' do
        hash = shop.to_hash(with_areas: { except: :created_at })
        expect(hash[:areas].length).to eq shop.areas.count
        shop.areas.each.with_index do |area, index|
          expect(hash[:areas][index]).to match(
            id: area.id,
            name: area.name,
            wide_area_id: area.wide_area_id,
            updated_at: area.updated_at
          )
        end
      end
    end
  end

  example 'Optinal attribute' do
    hash = shop.to_hash(with_foobar: true)
    expect(hash[:foobar]).to eq shop.foobar
  end

  context 'Scope option' do
    example 'One scope' do
      hash = shop.to_hash(with_areas: { scope: :ordered })
      expect(hash[:areas].length).to eq 3
      shop.areas.ordered.each.with_index do |area, index|
        expect(hash[:areas][index][:id]).to eq area.id
      end
    end

    example 'Multiple scope' do
      hash = shop.to_hash(with_areas: { scope: %i[ordered limit_one] })
      expect(hash[:areas].length).to eq 1
      expect(hash[:areas].first[:id]).to eq shop.areas.ordered.limit_one.first.id
    end

    example 'With Proc' do
      hash = shop.to_hash(with_areas: { scope: -> { order(id: :desc).limit(1) } })

      expect(hash[:areas].length).to eq 1
      expect(hash[:areas].first[:id]).to eq shop.areas.order(id: :desc).limit(1).first.id
    end
  end

  example 'attrs_reader' do
    expect(shop.to_hash(attrs_reader: :to_api_hash)).to match(shop.to_api_hash)
  end

  example 'proc attrs_reader' do
    expect(shop.to_hash(attrs_reader: ->(rec) { { foo: rec.id } })).to match(foo: shop.id)
  end

  example 'Multiple `with` options in on record' do
    hash = shop.to_hash(
      only: :name,
      with_areas: { only: :name },
      with_category: { only: :name }
    )
    expect(hash).to match(
      name: shop.name,
      areas: [
        { name: shop.areas[0].name },
        { name: shop.areas[1].name },
        { name: shop.areas[2].name }
      ],
      category: { name: shop.category.name }
    )
  end

  example 'pluck' do
    shop_hash = shop.to_hash(with_areas: { pluck: :id })

    expect(shop_hash[:areas]).to match([1, 2, 3])
  end

  example 'with args' do
    shop_hash = shop.to_hash(with_foobars: { args: ['a', 3] })
    expect(shop_hash[:foobars]).to match(%w[a a a])
  end

  example 'alter' do
    shop_hash = shop.to_hash(
      with_areas: {
        alter: lambda do |areas|
          areas.each_with_object({}) do |area, memo|
            memo[area[:id]] = area[:name]
          end
        end
      },
      alter: lambda do |shop|
        { shop_id: shop[:id] }
      end
    )

    expect(shop_hash).to match(
      shop_id: shop.id,
      areas: shop.areas.each_with_object({}) {|area, memo| memo[area.id] = area.name }
    )
  end

  example 'exists' do
    shop_hash = shop.to_hash(with_areas: :exists)
    expect(shop_hash[:areas]).to be true

    shop_hash = FactoryBot.create(:shop, with_out_areas: true).to_hash(with_areas: :exists)
    expect(shop_hash[:areas]).to be false
  end

  example 'value' do
    shop_hash = shop.to_hash(with_hogehoge: { value: 'pahupahu' })
    expect(shop_hash[:hogehoge]).to eq 'pahupahu'
  end

  example 'value with key' do
    shop_hash = shop.to_hash(with_hogehoge: { value: 'pahupahu', key: :dahhunda })
    expect(shop_hash[:dahhunda]).to eq 'pahupahu'
  end

  example 'false' do
    hash = shop.to_hash(with_areas: false)
    expect(hash.key?(:areas)).to be false
  end
end
