# frozen_string_literal: true
FactoryBot.define do
  factory :shop do
    transient do
      with_out_areas { false }
    end

    sequence(:name) {|n| "Shop No#{n}" }
    category
    after(:create) do |shop, evaluator|
      create_list(:area, 3, shops: [shop]) unless evaluator.with_out_areas
    end
  end
end
