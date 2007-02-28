require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the ActivationSignupsController should map" do
  controller_name :activation_signups
  include ActionController::UrlWriter

  specify "{ :controller => 'activation_signups', :action => 'index' } to /activation_signups" do
    route_for(:controller => "activation_signups", :action => "index").should_eql "/activation_signups"
  end
  
  specify "{ :controller => 'activation_signups', :action => 'new' } to /activation_signup" do
    route_for(:controller => "activation_signups", :action => "new").should_eql "/activation_signups/new"
  end
  
  specify "{ :controller => 'activation_signups', :action => 'show', :id => 1 } to /activation_signups/1" do
    route_for(:controller => "activation_signups", :action => "show", :id => 1).should_eql "/activation_signups/1"
  end
  
  specify "{ :controller => 'activation_signups', :action => 'edit', :id => 1 } to /activation_signups/1;edit" do
    route_for(:controller => "activation_signups", :action => "edit", :id => 1).should_eql "/activation_signups/1;edit"
  end
  
  specify "{ :controller => 'activation_signups', :action => 'update', :id => 1} to /activation_signups/1" do
    route_for(:controller => "activation_signups", :action => "update", :id => 1).should_eql "/activation_signups/1"
  end
  
  specify "{ :controller => 'activation_signups', :action => 'destroy', :id => 1} to /activation_signups/1" do
    route_for(:controller => "activation_signups", :action => "destroy", :id => 1).should_eql "/activation_signups/1"
  end
end

context "The ActivationSignupsController class" do
  controller_name :activation_signups
  # this is here so if we change the inheritance we need to write more tests
  specify "should inherit from EventsController" do
    ActivationSignupsController.ancestors.should_include EventsController
  end
end