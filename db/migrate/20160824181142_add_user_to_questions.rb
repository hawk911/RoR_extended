class AddUserToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :user_id, :integer
    add_index :questions, :user_id
    # add_reference :questions, :user, index: true, foreign_key: true
  end
end
