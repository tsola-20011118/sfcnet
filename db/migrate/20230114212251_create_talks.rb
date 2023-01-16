class CreateTalks < ActiveRecord::Migration[7.0]
  def change
    create_table :talks do |t|
      t.integer :to
      t.integer :from
      t.string :message

      t.timestamps
    end
  end
end
