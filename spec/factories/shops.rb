FactoryBot.define do
  factory :shop do
    sequence(:name) {|n| "Shop No#{n}" }
    after(:create) do |shop|
      create_list(:area, 3, shops: [shop])
    end
  end
end
