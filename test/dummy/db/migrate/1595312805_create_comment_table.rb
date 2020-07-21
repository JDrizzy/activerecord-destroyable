# frozen_string_literal: true

class CreateCommentTable < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.integer :post_id
    end
  end
end
