FactoryBot.define do
  factory :shop do
    name Faker::StarWars.planet
    after(:create) do |shop|
      create_list(:area, 3, shops: [shop])
    end
  end
end
