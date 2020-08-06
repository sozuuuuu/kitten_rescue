require 'test_helper'

class HappyPathTest < ActionDispatch::IntegrationTest
  test 'happy' do
    bus = Rails.configuration.command_bus
    es = Rails.configuration.event_store

    adoption_request_id = SecureRandom.uuid
    kitten_request_id_1 = SecureRandom.uuid
    kitten_request_id_2 = SecureRandom.uuid
    kitten_request_id_3 = SecureRandom.uuid

    bus.(Waiting::RequestAcceptance.new(request_id: adoption_request_id, color: 'white', requester: 'Genji'))
    bus.(Waiting::ApproveRequest.new(request_id: adoption_request_id, approver: 'Reinhardt'))
    bus.(Adoption::RequestKitten.new(request_id: kitten_request_id_1, color: 'any', requester: 'Mei'))
    bus.(Adoption::RequestKitten.new(request_id: kitten_request_id_2, color: 'white', requester: 'Hanzo'))
    bus.(Adoption::RequestKitten.new(request_id: kitten_request_id_3, color: 'black', requester: 'Doomfist'))

    deal_started_events = es.read.of_type([Dealing::Deal::DealStarted]).to_a
    # Because Doomfist requested a black cat.
    assert_equal(2, deal_started_events.length)

    # Because the adoption requester likes Hanzo
    deal_id = deal_started_events.find { |e| e.data[:kitten_request_id] == kitten_request_id_2 }.data[:deal_id]

    bus.(Dealing::CloseDeal.new(deal_id: deal_id))

    deal_closed_events = es.read.of_type([Dealing::Deal::DealClosed]).to_a
    assert_equal(1, deal_closed_events.length)
    closed_deal = Query::Deal.find_by(uid: deal_closed_events.first.data[:deal_id])
    assert_equal(kitten_request_id_2, closed_deal.kitten_request_id)

    deal_canceled_events = es.read.of_type([Dealing::Deal::DealCanceled]).to_a

    assert_equal(1, deal_canceled_events.length)
    canceled_deals = Query::Deal.where(uid: deal_canceled_events.map { |e| e.data[:deal_id] })

    assert_equal(1, canceled_deals.count)
    assert_equal(kitten_request_id_1, canceled_deals.first.kitten_request_id)
  end
end
