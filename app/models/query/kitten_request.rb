module Query
  class KittenRequest < ApplicationRecord
    def self.on_kitten_requested
      lambda do |event|
        create!(state: :requesting, color: event.data[:color], uid: event.data[:request_id], requester: event.data[:requester])
      end
    end
  end
end
