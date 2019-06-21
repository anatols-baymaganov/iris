# frozen_string_literal: true

FactoryBot.define do
  factory :versions_settings do
    key { Faker::Lorem.unique.word }
    value { FactoryBot::Helper.random_version }
  end
end
