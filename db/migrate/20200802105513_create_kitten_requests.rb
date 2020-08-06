class CreateKittenRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :kitten_requests do |t|
      t.string :state
      t.string :color
      t.string :requester

      t.timestamps
    end
  end
end
