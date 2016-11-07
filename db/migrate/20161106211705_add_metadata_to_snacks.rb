class AddMetadataToSnacks < ActiveRecord::Migration
  def change
    add_column :snacks, :metadata, :string
  end
end
