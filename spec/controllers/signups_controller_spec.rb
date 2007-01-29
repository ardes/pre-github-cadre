require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the SignupsController should map" do
  controller_name :signups
  include ActionController::UrlWriter
  
  specify "/sign_up and {:controller => 'signups', :action => 'new'}" do
    '/sign_up'.should_map_route_with :controller => 'signups', :action => 'new'
  end

  specify "named route: sign_up to /sign_up" do
    sign_up_path.should == '/sign_up'
  end

  specify "/signups/new to {:controller => 'signups', :action => 'new'}" do
    '/signups/new'.should_route_to :controller => 'signups', :action => 'new'
  end
  
  specify "{ :controller => 'signups', :action => 'show', :id => 1 } to /signups/1" do
    route_for(:controller => "signups", :action => "show", :id => 1).should_eql "/signups/1"
  end
  
  specify "{ :controller => 'signups', :action => 'edit', :id => 1 } to /signups/1;edit" do
    route_for(:controller => "signups", :action => "edit", :id => 1).should_eql "/signups/1;edit"
  end
  
  specify "{ :controller => 'signups', :action => 'update', :id => 1} to /signups/1" do
    route_for(:controller => "signups", :action => "update", :id => 1).should_eql "/signups/1"
  end
  
  specify "{ :controller => 'signups', :action => 'destroy', :id => 1} to /signups/1" do
    route_for(:controller => "signups", :action => "destroy", :id => 1).should_eql "/signups/1"
  end
end


context "The SignupController class" do
  controller_name :signups
  # this is here so if we change the inheritance we need to write more tests
  specify "should inherit from EventsController" do
    SignupsController.ancestors.should_include EventsController
  end
end