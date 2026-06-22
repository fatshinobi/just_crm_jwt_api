class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.text :about
      t.string :phone
      t.string :social
      t.references :user, null: false, foreign_key: true
      t.string :email

      t.timestamps
    end
  end
end
