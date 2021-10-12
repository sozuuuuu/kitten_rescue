class AddRequesterToAdoptionRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :adoption_requests, :requester, :string
  end
end
