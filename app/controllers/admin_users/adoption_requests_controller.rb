module AdminUsers
  class AdoptionRequestsController < ApplicationController
    def index
      @requests = AdoptionRequest.all.to_a
    end

    def new
      @request_id = SecureRandom.uuid
      @requester_id = params[:user_uid]
    end

    def create
      bus.(Waiting::RequestAcceptance.new(request_id: params[:request_id], color: params[:color], requester: params[:requester_id]))
      redirect_to "/users/#{params[:requester_id]}", notice: 'Thank you. We will get back you soon.'
    end
  end
end
