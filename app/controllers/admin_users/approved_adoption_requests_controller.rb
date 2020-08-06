module AdminUsers
  class ApprovedAdoptionRequestsController < ApplicationController
    def create
      bus.(Waiting::ApproveRequest.new(request_id: params[:request_id], approver: params[:admin_user_uid]))
      redirect_to "/admin_users/#{params[:admin_user_uid]}/adoption_requests", notice: "request: #{params[:request_id]} is approved"
    end
  end
end
