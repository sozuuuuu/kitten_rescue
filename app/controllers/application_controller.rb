class ApplicationController < ActionController::Base
  def bus
    Rails.configuration.command_bus
  end

  def es
    Rails.configuration.event_store
  end
end
