module Users
  class KittenRequestsController < ApplicationController
    def index
      @requests = KittenRequest.where(requester: params[:user_uid])
    end

    def new
      @request_id = SecureRandom.uuid
      @requester_id = params[:user_uid]
    end

    def create
      bus.(Adoption::RequestKitten.new(request_id: params[:request_id], color: params[:color], requester: params[:requester_id]))
      redirect_to "/users/#{params[:requester_id]}", notice: 'Thank you. Your request accepted.'
    end
  end
end
