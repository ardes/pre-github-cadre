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
end