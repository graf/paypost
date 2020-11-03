# frozen_string_literal: true

class CreateMerchants < ActiveRecord::Migration[6.0]
  def up
    create_merchants_status_enum

    create_table :merchants do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :description
      t.column :status, :merchants_status, default: :active, null: false
      t.decimal :total_transaction_sum, null: false, default: 0

      t.index :email, unique: true

      t.timestamps
    end
  end

  def down
    drop_table :merchants

    drop_merchants_status_enum
  end

  private

  def create_merchants_status_enum
    execute("CREATE TYPE merchants_status AS ENUM ('active', 'inactive');")
  end

  def drop_merchants_status_enum
    execute('DROP TYPE merchants_status;')
  end
end
