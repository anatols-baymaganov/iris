# frozen_string_literal: true

class Project < ActiveRecord::Base
  has_many :project_versions, dependent: :destroy

  validates :origin_id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true, format: URI.regexp(%w[http https])
end
