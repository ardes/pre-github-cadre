require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the EventsController should map" do
  controller_name :events

  specify "{ :controller => 'events', :action => 'index' } to /events" do
    route_for(:controller => "events", :action => "index").should_eql "/events"
  end
  
  specify "{ :controller => 'events', :action => 'new' } to /events/new" do
    route_for(:controller => "events", :action => "new").should_eql "/events/new"
  end
  
  specify "{ :controller => 'events', :action => 'show', :id => 1 } to /events/1" do
    route_for(:controller => "events", :action => "show", :id => 1).should_eql "/events/1"
  end
  
  specify "{ :controller => 'events', :action => 'edit', :id => 1 } to /events/1;edit" do
    route_for(:controller => "events", :action => "edit", :id => 1).should_eql "/events/1;edit"
  end
  
  specify "{ :controller => 'events', :action => 'update', :id => 1} to /events/1" do
    route_for(:controller => "events", :action => "update", :id => 1).should_eql "/events/1"
  end
  
  specify "{ :controller => 'events', :action => 'destroy', :id => 1} to /events/1" do
    route_for(:controller => "events", :action => "destroy", :id => 1).should_eql "/events/1"
  end
end

context "EventsController without HTTP_AUTH creds" do
  controller_name :events
  
  [:index, :show, :update, :edit, :create, :new, :destroy].each do |action|
    specify "should be unauthorized for #{action}" do
      get action
      response.response_code.should == 401
    end
  end
end

context "Requesting /events using GET" do
  controller_name :events

  setup do
    @events = mock('events')
    Event.stub!(:find).and_return(@events)
  end
  
  def do_get
    authorize_cadre_admin
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should_be_success
  end

  specify "should render index.rhtml" do
    controller.should_render :index
    do_get
  end
  
  specify "should find all events, including user, in reverse order of creation" do
    Event.should_receive(:find).with(:all, {:include => :user, :order => 'events.id DESC'}).and_return(@events)
    do_get
  end
  
  specify "should assign the found events for the view" do
    do_get
    assigns[:events].should_be @events
    
  end
end

context "Requesting /events.xml using GET" do
  controller_name :events

  setup do
    @events = mock('events')
    @events.stub!(:to_xml).and_return("XML")
    Event.stub!(:find).and_return(@events)
  end
  
  def do_get
    authorize_cadre_admin
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should_be_success
  end

  specify "should find all events, including user, in reverse order of creation" do
    Event.should_receive(:find).with(:all, {:include => :user, :order => 'events.id DESC'}).and_return(@events)
    do_get
  end
  
  specify "should render the found events as xml" do
    @events.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should_eql "XML"
  end
end

context "Requesting /events.atom using GET" do
  controller_name :events

  setup do
    @events = mock('events')
    Event.stub!(:find).and_return(@events)
    controller.stub!(:atom_feed_for).and_return('ATOM')
  end
  
  def do_get
    authorize_cadre_admin
    @request.env["HTTP_ACCEPT"] = "application/atom+xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should_be_success
  end

  specify "should find all events, including user, in reverse order of creation" do
    Event.should_receive(:find).with(:all, {:include => :user, :order => 'events.id DESC'}).and_return(@events)
    do_get
  end
  
  specify "should render the found events as atom feed" do
    controller.should_receive(:atom_feed_for).with(@events, controller.feed_options).and_return('ATOM')
    do_get
    response.body.should_eql "ATOM"
  end
end

context "Requesting /events.rss using GET" do
  controller_name :events

  setup do
    @events = mock('events')
    Event.stub!(:find).and_return(@events)
    controller.stub!(:rss_feed_for).and_return('RSS')
  end
  
  def do_get
    authorize_cadre_admin
    @request.env["HTTP_ACCEPT"] = "application/rss+xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should_be_success
  end

  specify "should find all events, including user, in reverse order of creation" do
    Event.should_receive(:find).with(:all, {:include => :user, :order => 'events.id DESC'}).and_return(@events)
    do_get
  end
  
  specify "should render the found events as rss feed" do
    controller.should_receive(:rss_feed_for).with(@events, controller.feed_options).and_return('RSS')
    do_get
    response.body.should_eql "RSS"
  end
end

context "Requesting /events/1 using GET" do
  controller_name :events

  setup do
    @event = mock('Event')
    Event.stub!(:find).and_return(@event)
  end
  
  def do_get
    authorize_cadre_admin
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should_be_success
  end
  
  specify "should render show.rhtml" do
    controller.should_render :show
    do_get
  end
  
  specify "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@event)
    do_get
  end
  
  specify "should assign the found event for the view" do
    do_get
    assigns[:event].should_be @event
  end
end

context "Requesting /events/1.xml using GET" do
  controller_name :events

  setup do
    @event = mock('Event')
    @event.stub!(:to_xml).and_return("XML")
    Event.stub!(:find).and_return(@event)
  end
  
  def do_get
    authorize_cadre_admin
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should_be_success
  end
  
  specify "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@event)
    do_get
  end
  
  specify "should render the found event as xml" do
    @event.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should_eql "XML"
  end
end

context "Requesting /events/new using GET" do
  controller_name :events

  setup do
    @event = mock('Event')
    @event.stub!(:ip_address=)
    @event.stub!(:ip_address)
    Event.stub!(:new).and_return(@event)
  end
  
  def do_get
    authorize_cadre_admin
    get :new
  end

  specify "should be successful" do
    do_get
    response.should_be_success
  end
  
  specify "should render new.rhtml" do
    controller.should_render :new
    do_get
  end
  
  specify "should create an new event" do
    Event.should_receive(:new).and_return(@event)
    do_get
  end
  
  specify "should set the event's ip_address to the remote_ip" do
    @event.should_receive(:ip_address=).with('0.0.0.0')
    do_get
  end
  
  specify "should not save the new event" do
    @event.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new event for the view" do
    do_get
    assigns[:event].should_be @event
  end
end

context "Requesting /events/1;edit using GET" do
  controller_name :events

  setup do
    @event = mock('Event')
    Event.stub!(:find).and_return(@event)
  end
  
  def do_get
    authorize_cadre_admin
    get :edit, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should_be_success
  end
  
  specify "should render edit.rhtml" do
    do_get
    controller.should_render :edit
  end
  
  specify "should find the event requested" do
    Event.should_receive(:find).and_return(@event)
    do_get
  end
  
  specify "should assign the found Event for the view" do
    do_get
    assigns(:event).should_equal @event
  end
end

context "Requesting /events using POST" do
  controller_name :events

  setup do
    @event = mock('Event')
    @event.stub!(:save).and_return(true)
    @event.stub!(:to_param).and_return("1")
    @event.stub!(:ip_address=)
    @event.stub!(:ip_address)
    Event.stub!(:new).and_return(@event)
  end
  
  def do_post
    authorize_cadre_admin
    post :create, :event => {:name => 'Event'}
  end
  
  specify "should create a new event" do
    Event.should_receive(:new).with({'name' => 'Event'}).and_return(@event)
    do_post
  end
  
  specify "should set the event's ip_address to the remote_ip" do
    @event.should_receive(:ip_address=).with('0.0.0.0')
    do_post
  end

  specify "should redirect to the new event" do
    do_post
    response.should_be_redirect
    response.redirect_url.should_eql "http://test.host/events/1"
  end
end

context "Requesting /events/1 using PUT" do
  controller_name :events

  setup do
    @event = mock('Event', :null_object => true)
    @event.stub!(:to_param).and_return("1")
    Event.stub!(:find).and_return(@event)
  end
  
  def do_update
    authorize_cadre_admin
    put :update, :id => "1"
  end
  
  specify "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@event)
    do_update
  end

  specify "should update the found event" do
    @event.should_receive(:update_attributes)
    do_update
    assigns(:event).should_be @event
  end

  specify "should assign the found event for the view" do
    do_update
    assigns(:event).should_be @event
  end

  specify "should redirect to the event" do
    do_update
    response.should_be_redirect
    response.redirect_url.should_eql "http://test.host/events/1"
  end
end

context "Requesting /events/1 using DELETE" do
  controller_name :events

  setup do
    @event = mock('Event', :null_object => true)
    Event.stub!(:find).and_return(@event)
  end
  
  def do_delete
    authorize_cadre_admin
    delete :destroy, :id => "1"
  end

  specify "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@event)
    do_delete
  end
  
  specify "should call destroy on the found event" do
    @event.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the events list" do
    do_delete
    response.should_be_redirect
    response.redirect_url.should_eql "http://test.host/events"
  end
end