class AddTalktempnumToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :talktempnum, :integer
  end
end
