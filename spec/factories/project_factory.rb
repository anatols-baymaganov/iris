# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    origin_id { Faker::Number.number(4).to_i }
    name { Faker::Lorem.unique.word }
    url { Faker::Internet.unique.url }

    transient do
      ruby { "2.3.3" }
      rails { "4.2.11.1" }
      rake { "10.0" }
      bundler { "1.17.2" }
      capistrano { "3.6.1" }
      capistrano_ruby { "2.3.3" }
    end

    after(:create) do |project, evaluator|
      {
        ruby:            evaluator.ruby,
        rails:           evaluator.rails,
        rake:            evaluator.rake,
        bundler:         evaluator.bundler,
        capistrano:      evaluator.capistrano,
        capistrano_ruby: evaluator.capistrano_ruby
      }.each do |key, value|
        create(:project_version, project: project, key: key, value: value)
      end
    end
  end
end
