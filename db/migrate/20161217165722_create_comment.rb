class CreateComment < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text    :body,             null: false
      t.integer :user_id,          null: false
      t.integer :commentable_id,   null: false
      t.string  :commentable_type, null: false
      t.timestamps
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
