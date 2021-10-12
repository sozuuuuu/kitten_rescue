require 'minitest/autorun'
require 'securerandom'
require 'arkency/command_bus'
require 'rails_event_store'

require_relative './test_helper'
require_relative '../adoption'

module Adoption
  class RequestKittenTest < Minitest::Test
    def setup
      @es = Container.resolve(:event_store)
      @bus = Container.resolve(:command_bus)
      @repository = Container.resolve(:repository)
    end

    def test_request_is_created
      @bus.register(RequestKitten, OnRequestKitten.new(repository: @repository))

      aggregate_id = SecureRandom.uuid
      stream = "Adoption::Request$#{aggregate_id}"
      command = RequestKitten.new(request_id: aggregate_id, color: 'any')
      @bus.call(command)
      events = @es.read.stream(stream).each.to_a
      assert_equal(1, events.length)
    end
  end
end
