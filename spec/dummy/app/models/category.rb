class Category < ApplicationRecord
  has_many :shops

  def to_api_hash
    {
      name: name
    }
  end
end
