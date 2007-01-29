class EventsController < ApplicationController
  rest_controller_for :events

protected
  def new_element(attrs = params[element_name])
    returning element_class.new(attrs) do |event|
      event.ip_address ||= request.remote_ip
    end
  end
end

