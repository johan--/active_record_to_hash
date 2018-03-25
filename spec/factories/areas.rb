FactoryBot.define do
  factory :area do
    name Faker::Address.city
    wide_area
  end
end
