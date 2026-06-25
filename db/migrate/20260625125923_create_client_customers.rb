class CreateClientCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :client_customers do |t|
      t.references :client, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
