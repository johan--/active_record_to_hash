class Shop < ApplicationRecord
  has_many :shop_areas
  has_many :areas, inverse_of: :shops, through: :shop_areas
end
