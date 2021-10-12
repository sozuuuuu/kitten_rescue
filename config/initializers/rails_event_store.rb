require 'rails_event_store'
require 'aggregate_root'
require 'arkency/command_bus'

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  # Subscribe event handlers below
  # Rails.configuration.event_store.tap do |store|
  #   store.subscribe(InvoiceReadModel.new, to: [InvoicePrinted])
  #   store.subscribe(->(event) { SendOrderConfirmation.new.call(event) }, to: [OrderSubmitted])
  #   store.subscribe_to_all_events(->(event) { Rails.logger.info(event.type) })
  # end
  Rails.configuration.event_store.tap do |store|
    store.subscribe(Query::AdoptionRequest.on_acceptance_requested, to: [Waiting::Request::AcceptanceRequested])
    store.subscribe(Query::AdoptionRequest.on_request_approved, to: [Waiting::Request::RequestApproved])
    store.subscribe(Query::KittenRequest.on_kitten_requested, to: [Adoption::KittenRequest::KittenRequested])
    store.subscribe(Query::Deal.on_deal_started, to: [Dealing::Deal::DealStarted])
    store.subscribe(Query::Deal.on_deal_closed, to: [Dealing::Deal::DealClosed])

    store.subscribe(Adoption::MatchingProcess, to: [
      Adoption::KittenRequest::KittenRequested
    ])
    store.subscribe(Dealing::DealingProcess, to: [
      Dealing::Deal::DealClosed
    ])
  end

  aggregate_repo = AggregateRoot::Repository.new
  # Register command handlers below
  # Rails.configuration.command_bus.tap do |bus|
  #   bus.register(PrintInvoice, Invoicing::OnPrint.new)
  #   bus.register(SubmitOrder,  ->(cmd) { Ordering::OnSubmitOrder.new.call(cmd) })
  # end
  Rails.configuration.command_bus.tap do |bus|
    bus.register(Waiting::RequestAcceptance, Waiting::OnAcceptanceRequested.new(repository: aggregate_repo))
    bus.register(Waiting::ApproveRequest, Waiting::OnRequestApproved.new(repository: aggregate_repo))
    bus.register(Adoption::RequestKitten, Adoption::OnRequestKitten.new(repository: aggregate_repo))
    bus.register(Dealing::StartDeal, Dealing::OnStartDeal.new(repository: aggregate_repo))
    bus.register(Dealing::CloseDeal, Dealing::OnCloseDeal.new(repository: aggregate_repo))
    bus.register(Dealing::CancelDeal, Dealing::OnCancelDeal.new(repository: aggregate_repo))
  end
end
