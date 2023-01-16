class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :age
      t.string :mail
      t.string :passward
      t.integer :sex
      t.boolean :taxi
      t.string :name

      t.timestamps
    end
  end
end
