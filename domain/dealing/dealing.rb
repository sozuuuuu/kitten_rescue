require 'dry-struct'
require 'dry-types'
require 'aggregate_root'

module Types
  include Dry::Types()
end

module Dealing
  class StartDeal < Dry::Struct
    attribute :deal_id, Dry::Types::String
    attribute :kitten_request_id, Dry::Types::String
    attribute :adoption_request_id, Dry::Types::String
  end

  class OnStartDeal
    def initialie(repository:)
      @repository = repository
    end

    def call(command)
      aggregate_id = command.deal_id
      stream = "Dealing::Deal$#{aggregate_id}"
      request = @repository.load(Deal.new, stream)
      request.request_acceptance(aggregate_id, command.kitten_request_id, command.adoption_request_id)
      @repository.store(request, stream)
    end
  end

  class Deal
    include AggregateRoot

    def start_deal(adoption_request_id, acceptance_request_id)
      apply DealStarted.new(data: {
        adoption_request_id: adoption_request_id,
        acceptance_request_id: acceptance_request_id
      })
    end

    private

    def apply_deal_started(event)
      @state = :started
      @adoption_request_id = event.data[:adoption_request_id]
      @acceptance_request_id = event.data[:acceptance_request_id]
    end
  end
end
