# frozen_string_literal: true

class ShopArea < ApplicationRecord
  belongs_to :shop
  belongs_to :area
end
