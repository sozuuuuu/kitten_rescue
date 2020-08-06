class AddApproverToAdoptionRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :adoption_requests, :approver, :string
  end
end
