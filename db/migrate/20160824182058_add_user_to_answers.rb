class AddUserToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :user_id, :integer
    add_index :answers, :user_id
    # add_reference :answers, :user, index: true, foreign_key: true
  end
end
