require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the ActivationsController should map" do
  controller_name :activations
  include ActionController::UrlWriter
  
  specify "/activate/id/key and {:controller => 'activations', :action => 'new', :signup_id => '1', :signup_key => 'key'}" do
    '/activate/1/key'.should_map_route_with :controller => 'activations', :action => 'new', :signup_id => '1', :signup_key => 'key'
  end

  specify "named route: activate {:signup_id => 1, :signup_key => 'key'} to /activate/1/key" do
    activate_path(1, 'key').should == '/activate/1/key'
  end

  specify "/activations/new to {:controller => 'activations', :action => 'new'}" do
    '/activations/new'.should_route_to :controller => 'activations', :action => 'new'
  end
  
  specify "{ :controller => 'activations', :action => 'show', :id => 1 } to /activations/1" do
    route_for(:controller => "activations", :action => "show", :id => 1).should_eql "/activations/1"
  end
  
  specify "{ :controller => 'activations', :action => 'edit', :id => 1 } to /activations/1;edit" do
    route_for(:controller => "activations", :action => "edit", :id => 1).should_eql "/activations/1;edit"
  end
  
  specify "{ :controller => 'activations', :action => 'update', :id => 1} to /activations/1" do
    route_for(:controller => "activations", :action => "update", :id => 1).should_eql "/activations/1"
  end
  
  specify "{ :controller => 'activations', :action => 'destroy', :id => 1} to /activations/1" do
    route_for(:controller => "activations", :action => "destroy", :id => 1).should_eql "/activations/1"
  end
end


context "The ActivationController class" do
  controller_name :activations
  # this is here so if we change the inheritance we need to write more tests
  specify "should inherit from EventsController" do
    ActivationsController.ancestors.should_include EventsController
  end
end