require 'minitest/autorun'
require 'securerandom'
require 'arkency/command_bus'
require 'rails_event_store'

require_relative './test_helper'
require_relative '../waiting'

module Waiting
  class ApproveRequestTest < Minitest::Test
    def setup
      @es = Container.resolve(:event_store)
      @bus = Container.resolve(:command_bus)
      @repository = Container.resolve(:repository)
    end

    def test_request_is_created
      @bus.register(RequestAcceptance, OnAcceptanceRequested.new(repository: @repository))

      aggregate_id = SecureRandom.uuid
      stream = "Waiting::Request$#{aggregate_id}"
      command = RequestAcceptance.new(request_id: aggregate_id, color: 'brown')
      events = @es.read.stream(stream).each.to_a
      assert_equal(1, events.length)
    end
  end
end
