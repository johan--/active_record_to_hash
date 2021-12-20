# frozen_string_literal: true

FactoryBot.define do
  factory :area do
    sequence(:name) {|n| "Area No#{n}" }
    wide_area
  end
end
