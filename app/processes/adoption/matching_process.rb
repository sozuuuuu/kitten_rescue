module Adoption
  class MatchingProcess
    def initialize(store: Rails.configuration.event_store, bus: Rails.configuration.commnad_bus)
      @store = store
      @bus = bus
    end

    def call(event)
      state = build_state(event)
      if state.matched.any?
        state.matched.each do |match|
          bus.call(Dealing::StartDeal.new(kitten_request_id: match.kitten_request_id, adoption_request_id: match.adoption_request_id))
        end
      end
    end

    private

    def build_state(event)
      stream = "Adoption::MatchingProcess#{event.data.fetch(:request_id)}"
      past = store.read.stream(stream).to_a
      last_stored = past.size - 1
      store.link(event.event_id, stream_name: stream, expected_version: last_stored)
      ProcessState.new.tap do |state|
        past.each { |event| state.call(event) }
        state.call(event)
      end
    rescue RubyEventStore::WrongExpectedEventVersion
      retry
    end

    class ProcessState
      def initialize
        @kitten_requests = []
        @adoption_requests = []
      end

      def call(event)
        case event
        when Waiting::RequestApproved
        end
      end
    end
  end
end
