class AddUidToKittenRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :kitten_requests, :uid, :string
  end
end
