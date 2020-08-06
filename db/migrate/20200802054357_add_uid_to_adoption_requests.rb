class AddUidToAdoptionRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :adoption_requests, :uid, :string
  end
end
