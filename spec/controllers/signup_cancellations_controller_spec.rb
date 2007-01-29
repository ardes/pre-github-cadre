require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the SignupCancellationsController" do
  controller_name :signup_cancellations
  include ActionController::UrlWriter
  
  specify "should map '/cancel/id/key' with {:controller => 'signup_cancellations', :action => 'new', :signup_id => '1', :signup_key => 'key'}" do
    '/cancel/1/key'.should_map_route_with :controller => 'signup_cancellations', :action => 'new', :signup_id => '1', :signup_key => 'key'
  end

  specify "has named route cancel_signup {:signup_id => 1, :signup_key => 'key'} generating /cancel/1/key" do
    cancel_signup_path(:signup_id => 1, :signup_key => 'key').should == '/cancel/1/key'
  end

  specify "should route '/signup_cancellations/new' to {:controller => 'signup_cancellations', :action => 'new'}" do
    '/signup_cancellations/new'.should_route_to :controller => 'signup_cancellations', :action => 'new'
  end

  specify "{ :controller => 'signup_cancellations', :action => 'show', :id => 1 } to /signup_cancellations/1" do
    route_for(:controller => "signup_cancellations", :action => "show", :id => 1).should_eql "/signup_cancellations/1"
  end

  specify "{ :controller => 'signup_cancellations', :action => 'edit', :id => 1 } to /signup_cancellations/1;edit" do
    route_for(:controller => "signup_cancellations", :action => "edit", :id => 1).should_eql "/signup_cancellations/1;edit"
  end

  specify "{ :controller => 'signup_cancellations', :action => 'update', :id => 1} to /signup_cancellations/1" do
    route_for(:controller => "signup_cancellations", :action => "update", :id => 1).should_eql "/signup_cancellations/1"
  end

  specify "{ :controller => 'signup_cancellations', :action => 'destroy', :id => 1} to /signup_cancellations/1" do
    route_for(:controller => "signup_cancellations", :action => "destroy", :id => 1).should_eql "/signup_cancellations/1"
  end
end


context "The SignupCancellationsController class" do
  controller_name :signup_cancellations
  # this is here so if we change the inheritance we need to write more tests
  specify "should inherit from EventsController" do
    SignupCancellationsController.ancestors.should_include EventsController
  end
end
