class AddFlagToTalk < ActiveRecord::Migration[7.0]
  def change
    add_column :talks, :flag, :float
  end
end
