require 'dry-struct'
require 'dry-types'
require 'aggregate_root'

module Types
  include Dry::Types()
end

module Waiting
  # commands
  class RequestAcceptance < Dry::Struct
    VALID_COLORS = ['white', 'black', 'brown']
    COLORS = Types::String.enum(*VALID_COLORS)
    attribute :request_id, Types::String
    attribute :color, COLORS
    attribute :requester, Types::String
  end

  class ApproveRequest < Dry::Struct
    attribute :request_id, Types::String
    attribute :approver, Types::String
  end

  # command handlers
  class OnAcceptanceRequested
    def initialize(repository:)
      @repository = repository
    end

    def call(command)
      aggregate_id = command.request_id
      stream = "Waiting::Request$#{aggregate_id}"
      request = @repository.load(Request.new, stream)
      request.request_acceptance(aggregate_id, command.color, command.requester)
      @repository.store(request, stream)
    end
  end

  class OnRequestApproved
    def initialize(repository:)
      @repository = repository
    end

    def call(command)
      aggregate_id = command.request_id
      stream = "Waiting::Request$#{aggregate_id}"
      request = @repository.load(Request.new, stream)
      request.approve(aggregate_id, command.approver)
      @repository.store(request, stream)
    end
  end

  # entities
  class Request
    include AggregateRoot

    # events
    class AcceptanceRequested < RailsEventStore::Event; end
    class RequestApproved < RailsEventStore::Event; end

    def initialize
      @state = :new
    end

    def request_acceptance(request_id, color, requester)
      # @id is no longer available!!!
      event = AcceptanceRequested.new(data: { request_id: request_id, color: color, requester: requester })
      apply event
    end

    def approve(request_id, approver)
      apply RequestApproved.new(data: { request_id: request_id, by: approver })
    end

    private

    def apply_acceptance_requested(event); end

    def apply_request_approved(event); end
  end
end
