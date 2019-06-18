# frozen_string_literal: true

class CreateVersionsSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :versions_settings do |t|
      t.string :key, null: false
      t.text :value, null: false
    end

    add_index :versions_settings, :key, unique: true
  end
end
