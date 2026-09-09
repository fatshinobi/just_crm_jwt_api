class AddDeletedAtToOpportunity < ActiveRecord::Migration[8.1]
  def change
    add_column :opportunities, :deleted_at, :datetime
    add_index :opportunities, :deleted_at
  end
end
