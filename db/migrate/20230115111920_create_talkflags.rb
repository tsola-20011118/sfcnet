class CreateTalkflags < ActiveRecord::Migration[7.0]
  def change
    create_table :talkflags do |t|
      t.integer :first
      t.integer :second

      t.timestamps
    end
  end
end
