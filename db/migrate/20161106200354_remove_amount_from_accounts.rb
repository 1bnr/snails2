class RemoveAmountFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :amount
  end
end
