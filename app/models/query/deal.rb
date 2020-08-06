module Query
  class Deal < ApplicationRecord
    def state
      self[:state].to_sym
    end

    def self.on_deal_started
      lambda do |event|
        create!(uid: event.data[:deal_id], adoption_request_id: event.data[:adoption_request_id], kitten_request_id: event.data[:kitten_request_id], state: :negotiating)
      end
    end

    def self.on_deal_closed
      lambda do |event|
        find_by!(uid: event.data[:deal_id]).update!(state: :closed)
      end
    end
  end
end

