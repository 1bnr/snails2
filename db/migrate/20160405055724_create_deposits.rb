class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.integer :account_id
      t.decimal :amount, precision: 8, scale: 2
      t.timestamps null: false
    end
    add_index :deposits, :account_id
  end
end
