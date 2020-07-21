# frozen_string_literal: true

class CreatePostTable < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.integer :user_id
    end
  end
end
