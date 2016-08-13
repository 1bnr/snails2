class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.belongs_to :user, index: true
      t.decimal :amount, precision: 8, scale: 2
      t.timestamps null: false
    end
  end
end
