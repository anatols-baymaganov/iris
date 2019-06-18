# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.integer :origin_id, null: false
      t.string :name, null: false
      t.string :url, null: false
      t.datetime :updated_at, null: false
    end

    add_index :projects, :origin_id, unique: true
    add_index :projects, :name, unique: true
    add_index :projects, :url, unique: true
  end
end
