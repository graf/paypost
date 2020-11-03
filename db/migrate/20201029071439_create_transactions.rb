# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[6.0]
  def up
    create_transactions_status_enum

    create_table :transactions do |t|
      t.string :uuid, null: false
      t.decimal :amount
      t.column :status, :transactions_status, null: false
      t.string :customer_email
      t.string :customer_phone

      t.index :uuid, unique: true

      setup_sti(t)
      setup_references(t)

      t.timestamps
    end
  end

  def down
    drop_table :transactions

    drop_transactions_status_enum
  end

  private

  def setup_sti(table)
    table.string :type, null: false
    table.index %i[type id]
  end

  def setup_references(table)
    table.references :parent_transaction, foreign_key: { to_table: :transactions }
    table.references :merchant, foreign_key: true, null: false
  end

  def create_transactions_status_enum
    execute(<<~SQL.squish)
      CREATE TYPE transactions_status 
      AS ENUM ('approved', 'reversed', 'refunded', 'error');
    SQL
  end

  def drop_transactions_status_enum
    execute('DROP TYPE transactions_status;')
  end
end
