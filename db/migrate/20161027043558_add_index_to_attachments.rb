class AddIndexToAttachments < ActiveRecord::Migration[5.0]
  def change
    add_index :attachments, :attachable_id
  end
end
