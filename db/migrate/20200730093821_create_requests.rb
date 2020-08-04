# frozen_string_literal: true

class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :biography
      t.integer :status, default: 0

      t.string :confirmation_code

      t.boolean :is_expiration_warned, default: false

      t.datetime :last_confirmation
      t.timestamps
    end
  end
end
