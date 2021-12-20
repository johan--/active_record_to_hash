# frozen_string_literal: true
FactoryBot.define do
  factory :wide_area do
    sequence(:name) {|n| "Wide Area No#{n}" }
  end
end
