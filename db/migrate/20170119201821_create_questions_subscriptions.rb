class CreateQuestionsSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_join_table :questions, :users, table_name: :questions_subscriptions do |t|
      t.index :user_id
      t.index :question_id
    end

    add_foreign_key :questions_subscriptions, :users
    add_foreign_key :questions_subscriptions, :questions
  end
end
