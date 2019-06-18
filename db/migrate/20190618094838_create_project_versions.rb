# frozen_string_literal: true

class CreateProjectVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :project_versions do |t|
      t.belongs_to :project, foreign_key: true, index: true
      t.string :key, null: false
      t.string :value
    end

    add_index :project_versions, %i[project_id key], unique: true
  end
end
