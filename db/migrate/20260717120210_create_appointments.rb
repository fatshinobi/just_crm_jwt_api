class CreateAppointments < ActiveRecord::Migration[8.1]
  def change
    create_table :appointments do |t|
      t.text :about
      t.references :customer, null: false, foreign_key: true
      t.references :client, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :communication_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.datetime :when

      t.timestamps
    end
  end
end
