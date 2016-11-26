class AddIsBestToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :is_best, :boolean, default: false, null: false
  end
end
