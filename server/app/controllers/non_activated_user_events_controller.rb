class NonActivatedUserEventsController < EventsController

  def create
    # massage signup id and key into params hash
    params[resource_name] ||= {:signup_key => params[:signup_key], :signup_id => params[:signup_id]}
    
    self.resource = new_resource

    # don't redirect to new resource, as it (i) might have been destroyed, or (ii) it's not important
    respond_to do |format|
      if resource.save
        format.html { render :action => "create" }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => resource.errors.to_xml, :status => 422 }
      end
    end
  end
end
