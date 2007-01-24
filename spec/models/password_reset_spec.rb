require File.dirname(__FILE__) + '/../spec_helper'

context "A PasswordReset (in general)" do
  fixtures :events
  
  setup do
    @event = PasswordReset.new
  end
  
  specify "gracefully loads :request from :request_id and :request_key, unless it is set" do
    @event.request.should_be_nil
    @event.request_id = 4
    @event.request.should_be_nil
    @event.request_key = '34a350336e79e39e2d3244cee34f791c'
    @event.request.should == events(:password_reset_request_fred)
    @event.request = 'foo'
    @event.request.should == 'foo'
  end
  
  specify "should protect :request from mass assignment" do
    @event.attributes = {:request => events(:password_reset_request_fred)}
    @event.request.should_be_nil
  end
end

context "A new PasswordReset" do
  fixtures :users, :events, :event_properties

  setup do
    @event = PasswordReset.new :request_id => 4, :request_key => '34a350336e79e39e2d3244cee34f791c' # begin with a valid PasswordReset
  end
  
  specify "should be invalid when :request is nil" do 
    @event.request_id = 666
    @event.should_not_be_valid
    @event.errors.full_messages.should_include "Request is not valid"
  end
  
  specify "should be invalid when :request is a new record" do
    @event.request = PasswordResetRequest.new
    @event.should_not_be_valid
    @event.errors.full_messages.should_include "Request is not valid"
  end
  
  specify "should be valid with existing request" do
    @event.should_be_valid
  end
end