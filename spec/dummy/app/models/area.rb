class Area < ApplicationRecord
  belongs_to :wide_area
  has_many :shop_areas
  has_many :shops, inverse_of: :areas, through: :shop_areas
end
