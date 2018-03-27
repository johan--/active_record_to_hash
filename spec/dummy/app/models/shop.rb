class Shop < ApplicationRecord
  has_many :shop_areas
  has_many :areas, inverse_of: :shops, through: :shop_areas
  belongs_to :category

  def foobar
    "#{name} foobar"
  end

  def to_api_hash
    {
      id: id,
      name: "#front #{name}"
    }
  end
end
