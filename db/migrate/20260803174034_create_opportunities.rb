class CreateOpportunities < ActiveRecord::Migration[8.1]
  def change
    create_table :opportunities do |t|
      t.references :client, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.date :start
      t.date :finish
      t.text :description
      t.decimal :amount, precision: 8, scale: 2
      t.integer :stage
      t.integer :status

      t.timestamps
    end
  end
end
