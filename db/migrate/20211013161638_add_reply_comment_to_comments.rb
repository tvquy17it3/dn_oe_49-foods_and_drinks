class AddReplyCommentToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :reply_comment, :integer
  end
end
