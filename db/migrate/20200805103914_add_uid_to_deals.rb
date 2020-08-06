class AddUidToDeals < ActiveRecord::Migration[6.0]
  def change
    add_column :deals, :uid, :string
  end
end
