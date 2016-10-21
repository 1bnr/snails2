class AddItemNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :item_num, :int
  end
end
