class EventsController < ApplicationController
  resources_controller_for :events

protected
  def new_resource
    returning resource_service.new(params[resource_name]) do |event|
      event.ip_address ||= request.remote_ip
    end
  end
end

