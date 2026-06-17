class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.text :about
      t.text :address
      t.string :phone
      t.string :web
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
