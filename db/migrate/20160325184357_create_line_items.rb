class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :snack_id
      t.timestamps null: false
      t.belongs_to :order, index: true
    end
    add_index :line_items, :snack_id
  end
end
