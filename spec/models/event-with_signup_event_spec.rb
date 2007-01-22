require File.dirname(__FILE__) + '/../spec_helper'

context "A WithSignupEvent (in general)" do
  fixtures :events
  
  setup do
    @event = WithSignupEvent.new
  end
  
  specify "gracefully loads :signup from :signup_id and :signup_key, unless it is set" do
    @event.signup.should_be_nil
    @event.signup_id = 2
    @event.signup.should_be_nil
    @event.signup_key = 'e3907e189595061ac246459ede9600d8'
    @event.signup.should == events(:signup_joe)
    
    @event.signup = events(:signup_fred)
    @event.signup.should == events(:signup_fred)
  end
  
  specify "should protect :signup from mass assignment" do
    @event.attributes = {:signup => events(:signup_fred)}
    @event.signup.should_be_nil
  end
end

context "A new WithSignupEvent" do
  fixtures :users, :events, :event_properties

  setup do
    @event = WithSignupEvent.new :signup_id => 2, :signup_key => 'e3907e189595061ac246459ede9600d8' # begin with a valid signup
  end
  
  specify "should be invalid when :signup is nil" do 
    @event.signup_id = 666
    @event.should_not_be_valid
    @event.errors.full_messages.should_include "Signup is not valid"
  end
  
  specify "should be invalid when :signup is a new record" do
    @event.signup = Signup.new
    @event.should_not_be_valid
    @event.errors.full_messages.should_include "Signup is not valid"
  end
  
  specify "should be invalid if signup.user is already activated" do
    @event.signup = events(:signup_fred)
    @event.should_not_be_valid
    @event.errors.full_messages.should_include "User is already activated"
  end
  
  specify "should be valid with existing signup, if user is not activated" do
    @event.should_be_valid
  end
end