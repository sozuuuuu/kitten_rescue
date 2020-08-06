require 'dry-struct'
require 'dry-types'


module Types
  include Dry::Types()
end

module Adoption
  class RequestKitten < Dry::Struct
    VALID_COLORS = ['any', 'white', 'black', 'brown']
    COLORS = Types::String.enum(*VALID_COLORS)
    attribute :request_id, Types::String
    attribute :color, COLORS
    attribute :requester, Types::String

    alias aggregate_id request_id
  end

  class OnRequestKitten
    def initialize(repository:)
      @repository = repository
    end

    def call(command)
      request_id = command.request_id
      stream = "Adoption::Request$#{request_id}"
      request = @repository.load(KittenRequest.new, stream)
      request.create_request(request_id, command.color, command.requester)
      @repository.store(request, stream)
    end
  end

  class KittenRequest
    include AggregateRoot

    KittenRequested = Class.new(RailsEventStore::Event)

    def create_request(request_id, color, requester)
      apply KittenRequested.new(data: { color: color, request_id: request_id, requester: requester })
    end

    private

    def apply_kitten_requested(event); end
  end
end
