class CreateAdoptionRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :adoption_requests do |t|
      t.string :state
      t.string :color

      t.timestamps
    end
  end
end
