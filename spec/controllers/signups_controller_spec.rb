require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the SignupsController should map" do
  controller_name :signups

  specify "{ :controller => 'signups', :action => 'index' } to /signups" do
    route_for(:controller => "signups", :action => "index").should_eql "/signups"
  end
  
  specify "/signups/new to { :controller => 'signups', :action => 'new' }" do
    '/signups/new'.should_route_to :controller => 'signups', :action => 'new'
  end
  
  specify "{ :controller => 'signups', :action => 'new' } to /sign_up" do
    route_for(:controller => "signups", :action => "new").should_eql "/sign_up"
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