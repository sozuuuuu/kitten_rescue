module Query
  class AdoptionRequest < ApplicationRecord
    def self.on_acceptance_requested
      lambda do |event|
        # state transition is duplicated with domain model. is that OK...?
        create!(state: :wait_for_approval, color: event.data[:color], uid: event.data[:request_id], requester: event.data[:requester])
      end
    end

    def self.on_request_approved
      lambda do |event|
        request = find_by!(uid: event.data[:request_id])
        request.update(approver: event.data[:approver], state: :approved)
      end
    end
  end
end
