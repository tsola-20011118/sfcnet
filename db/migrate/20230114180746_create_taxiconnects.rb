class CreateTaxiconnects < ActiveRecord::Migration[7.0]
  def change
    create_table :taxiconnects do |t|
      t.integer :to
      t.integer :from

      t.timestamps
    end
  end
end
