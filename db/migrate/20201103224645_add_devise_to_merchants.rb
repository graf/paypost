# frozen_string_literal: true

class AddDeviseToMerchants < ActiveRecord::Migration[6.0]
  def change
    change_table(:merchants, bulk: true) do |t|
      t.string :encrypted_password, null: false, default: ''
      t.string :provider, null: false, default: 'email'
      t.string :uid, null: false, default: ''
      t.json :tokens
      t.index %i[uid provider], unique: true
    end
  end
end
