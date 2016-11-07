class AddIsAdminToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :is_admin, :boolean, :null => false, :default => FALSE
  end
end
