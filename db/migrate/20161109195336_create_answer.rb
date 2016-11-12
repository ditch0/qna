class CreateAnswer < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.text       :body,     null: false
      t.references :question, null: false

      t.timestamps null: false
    end
  end
end
