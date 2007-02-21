class EventsController < ApplicationController
  resources_controller_for :events
  inherit_views

  # For events that generate a key, we return that in the header.  The cadre client
  # knows to attach this as an attribute if it is present
  #
  # The key is returned in the header because it does not persist in the database.  It
  # is either sent in an email, or kept by the client for future authentication.
  def create
    self.resource = new_resource

    respond_to do |format|
      if resource.save
        flash[:notice] = "#{resource_name.humanize} was successfully created."
        format.html { redirect_to resource_url }
        format.xml do
          header_attrs = {:location => resource_url}
          header_attrs.merge!(:key => resource.key) if resource.respond_to?(:key)
          head :created, header_attrs
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => resource.errors.to_xml, :status => 422 }
      end
    end
  end

protected
  def new_resource
    returning resource_service.new(params[resource_name]) do |event|
      event.ip_address ||= request.remote_ip
    end
  end
end

