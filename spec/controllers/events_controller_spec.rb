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

context "Requesting /events using GET" do
  controller_name :events

  setup do
    @mock_events = mock('events')
    Event.stub!(:find).and_return(@mock_events)
  end
  
  def do_get
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
  
  specify "should find all events" do
    Event.should_receive(:find).with(:all).and_return(@mock_events)
    do_get
  end
  
  specify "should assign the found events for the view" do
    do_get
    assigns[:events].should_be @mock_events
    
  end
end

context "Requesting /events.xml using GET" do
  controller_name :events

  setup do
    @mock_events = mock('events')
    @mock_events.stub!(:to_xml).and_return("XML")
    Event.stub!(:find).and_return(@mock_events)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should_be_success
  end

  specify "should find all events" do
    Event.should_receive(:find).with(:all).and_return(@mock_events)
    do_get
  end
  
  specify "should render the found events as xml" do
    @mock_events.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should_eql "XML"
  end
end

context "Requesting /events/1 using GET" do
  controller_name :events

  setup do
    @mock_event = mock('Event')
    Event.stub!(:find).and_return(@mock_event)
  end
  
  def do_get
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
    Event.should_receive(:find).with("1").and_return(@mock_event)
    do_get
  end
  
  specify "should assign the found event for the view" do
    do_get
    assigns[:event].should_be @mock_event
  end
end

context "Requesting /events/1.xml using GET" do
  controller_name :events

  setup do
    @mock_event = mock('Event')
    @mock_event.stub!(:to_xml).and_return("XML")
    Event.stub!(:find).and_return(@mock_event)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should_be_success
  end
  
  specify "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@mock_event)
    do_get
  end
  
  specify "should render the found event as xml" do
    @mock_event.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should_eql "XML"
  end
end

context "Requesting /events/new using GET" do
  controller_name :events

  setup do
    @mock_event = mock('Event')
    @mock_event.stub!(:ip_address=)
    @mock_event.stub!(:ip_address)
    Event.stub!(:new).and_return(@mock_event)
  end
  
  def do_get
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
    Event.should_receive(:new).and_return(@mock_event)
    do_get
  end
  
  specify "should set the event's ip_address to the remote_ip" do
    @mock_event.should_receive(:ip_address=).with('0.0.0.0')
    do_get
  end
  
  specify "should not save the new event" do
    @mock_event.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new event for the view" do
    do_get
    assigns[:event].should_be @mock_event
  end
end

context "Requesting /events/1;edit using GET" do
  controller_name :events

  setup do
    @mock_event = mock('Event')
    Event.stub!(:find).and_return(@mock_event)
  end
  
  def do_get
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
    Event.should_receive(:find).and_return(@mock_event)
    do_get
  end
  
  specify "should assign the found Event for the view" do
    do_get
    assigns(:event).should_equal @mock_event
  end
end

context "Requesting /events using POST" do
  controller_name :events

  setup do
    @mock_event = mock('Event')
    @mock_event.stub!(:save).and_return(true)
    @mock_event.stub!(:to_param).and_return("1")
    @mock_event.stub!(:ip_address=)
    @mock_event.stub!(:ip_address)
    Event.stub!(:new).and_return(@mock_event)
  end
  
  def do_post
    post :create, :event => {:name => 'Event'}
  end
  
  specify "should create a new event" do
    Event.should_receive(:new).with({'name' => 'Event'}).and_return(@mock_event)
    do_post
  end
  
  specify "should set the event's ip_address to the remote_ip" do
    @mock_event.should_receive(:ip_address=).with('0.0.0.0')
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
    @mock_event = mock('Event', :null_object => true)
    @mock_event.stub!(:to_param).and_return("1")
    Event.stub!(:find).and_return(@mock_event)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@mock_event)
    do_update
  end

  specify "should update the found event" do
    @mock_event.should_receive(:update_attributes)
    do_update
    assigns(:event).should_be @mock_event
  end

  specify "should assign the found event for the view" do
    do_update
    assigns(:event).should_be @mock_event
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
    @mock_event = mock('Event', :null_object => true)
    Event.stub!(:find).and_return(@mock_event)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@mock_event)
    do_delete
  end
  
  specify "should call destroy on the found event" do
    @mock_event.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the events list" do
    do_delete
    response.should_be_redirect
    response.redirect_url.should_eql "http://test.host/events"
  end
end