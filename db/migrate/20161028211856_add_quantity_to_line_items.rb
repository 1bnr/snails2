class AddQuantityToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :qntity, :int
  end
end
