class CreateQuestionSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :question_subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true

      t.timestamps
    end

    add_index :question_subscriptions, [:user_id, :question_id], unique: true
  end
end
