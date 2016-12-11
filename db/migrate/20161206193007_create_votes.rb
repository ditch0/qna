class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :value,        null: false
      t.integer :user_id,      null: false
      t.integer :votable_id,   null: false
      t.string  :votable_type, null: false
      t.timestamps
    end

    add_index :votes, [:votable_id, :votable_type]
  end
end
