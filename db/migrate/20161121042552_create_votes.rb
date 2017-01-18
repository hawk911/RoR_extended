class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :value
      t.integer :votable_id
      t.string :votable_type
<<<<<<< HEAD
      t.references :user, index: true, foreign_key: true
=======
      t.references :user, index: true, foreign_key:true
>>>>>>> 1b85e5a1b3adf3e0c06fbe0cafa926989c608a61
      t.timestamps
    end

    add_index :votes, [:votable_id, :votable_type]
  end
end
