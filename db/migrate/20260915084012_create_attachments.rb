class CreateAttachments < ActiveRecord::Migration[8.1]
  def change
    create_table :attachments do |t|
      t.string :description
      t.integer :attachment_type, null: false, default: 0
      t.integer :attachable_id
      t.string :attachable_type

      t.timestamps
    end
  end
end
