class EventsController < ApplicationController
  rest_for :events

  before_filter do |c| # set ip_address whenever params are sent to the controller
    c.params[element_name][:ip_address] = c.request.remote_ip if c.params[element_name]
  end
end

