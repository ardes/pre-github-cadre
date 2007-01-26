require File.dirname(__FILE__) + '/../spec_helper'

context "The NonActivatedUserEvent class" do
  specify "should have event_key :signup" do
    NonActivatedUserEvent.included_modules.should_include KeyEvent::Has
    NonActivatedUserEvent.instance_methods.should_include "signup"
  end
end

context "A NonActivatedUserEvent (in general)" do
  fixtures :users, :events, :event_properties
  
  setup do
    @event = NonActivatedUserEvent.new
  end
  
  specify "should raise ArgumentError if user is accessed before signup is set" do
    lambda{ @event.user }.should_raise ArgumentError, 'assign signup before accessing user'
  end
  
  specify "should load user from signup" do
    @event.signup = events(:signup_fred)
    @event.user.should == users(:fred)
  end
end
  
context "A new NonActivatedUserEvent" do
  fixtures :users, :events, :event_properties

  setup do
    @event = NonActivatedUserEvent.new :signup_id => 2, :signup_key => 'e3907e189595061ac246459ede9600d8' # begin valid
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