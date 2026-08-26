class CreateOpportunityTags < ActiveRecord::Migration[8.1]
  def change
    create_table :opportunity_tags do |t|
      t.references :opportunity, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
