require 'dry-struct'
require 'dry-types'
require 'aggregate_root'

module Types
  include Dry::Types()
end

module Dealing
  class StartDeal < Dry::Struct
    attribute :deal_id, Types::String
    attribute :kitten_request_id, Types::String
    attribute :adoption_request_id, Types::String
  end

  class CloseDeal < Dry::Struct
    attribute :deal_id, Types::String
  end

  class CancelDeal < Dry::Struct
    attribute :deal_id, Types::String
    attribute :reason, Types::String
  end

  class OnStartDeal
    def initialize(repository:)
      @repository = repository
    end

    def call(command)
      deal_id = command.deal_id
      stream = "Dealing::Deal$#{deal_id}"
      request = @repository.load(Deal.new, stream)
      request.start_deal(deal_id, command.adoption_request_id, command.kitten_request_id)
      @repository.store(request, stream)
    end
  end

  class OnCloseDeal
    def initialize(repository:)
      @repository = repository
    end

    def call(command)
      deal_id = command.deal_id
      stream = "Dealing::Deal$#{deal_id}"
      deal = @repository.load(Deal.new, stream)
      deal.close(deal_id)
      @repository.store(deal, stream)
    end
  end

  class OnCancelDeal
    def initialize(repository:)
      @repository = repository
    end

    def call(command)
      deal_id = command.deal_id
      stream = "Dealing::Deal$#{deal_id}"
      deal = @repository.load(Deal.new, stream)
      deal.cancel(deal_id, command.reason)
      @repository.store(deal, stream)
    end
  end

  class Deal
    include AggregateRoot

    class DealStarted < RailsEventStore::Event; end
    class DealClosed < RailsEventStore::Event; end
    class DealCanceled < RailsEventStore::Event; end

    def start_deal(deal_id, adoption_request_id, kitten_request_id)
      apply DealStarted.new(data: {
        deal_id: deal_id,
        adoption_request_id: adoption_request_id,
        kitten_request_id: kitten_request_id
      })
    end

    def close(deal_id)
      apply DealClosed.new(data: {
        deal_id: deal_id
      })
    end

    def cancel(deal_id, reason)
      apply DealCanceled.new(data: {
        deal_id: deal_id,
        reason: reason
      })
    end

    private

    def apply_deal_started(_event); end
    def apply_deal_closed(_event); end
    def apply_deal_canceled(_event); end
  end
end
