class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string  :file,                null: false
      t.integer :attachmentable_id,   null: false
      t.string  :attachmentable_type, null: false
      t.timestamps
    end

    add_index :attachments, [:attachmentable_id, :attachmentable_type]
  end
end
