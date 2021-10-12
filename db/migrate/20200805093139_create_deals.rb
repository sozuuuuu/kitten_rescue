class CreateDeals < ActiveRecord::Migration[6.0]
  def change
    create_table :deals do |t|
      t.string :adoption_request_id
      t.string :kitten_request_id
      t.string :state

      t.timestamps
    end
  end
end
