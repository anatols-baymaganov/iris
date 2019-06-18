# frozen_string_literal: true

class ProjectVersion < ActiveRecord::Base
  belongs_to :project

  validates :key, presence: true, uniqueness: { scope: :project_id }
  validates :value, version_format: true, if: -> { value.present? }
end
