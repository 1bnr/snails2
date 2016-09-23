class AddImagetoSnacks < ActiveRecord::Migration
  def change
    add_column :snacks, :image, :string
  end
end
