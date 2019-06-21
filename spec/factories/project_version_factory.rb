# frozen_string_literal: true

FactoryBot.define do
  factory :project_version do
    key { Faker::Lorem.unique.word }
    value { FactoryBot::Helper.random_version }
  end
end
