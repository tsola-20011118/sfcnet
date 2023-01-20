class AddRtaxiUser < ActiveRecord::Migration[7.0]
  def change
    add_column :rtaxi, :boolean
  end
end
