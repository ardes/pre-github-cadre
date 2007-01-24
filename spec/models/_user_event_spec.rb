require File.dirname(__FILE__) + '/../spec_helper'

context "A new User Event (and subclasses)" do
  fixtures :events, :event_properties
  
  setup do
    @user_event = UserEvent.new
    @user_event.user_id = 1 # start with a valid UserEvent
  end

  specify "should be invalid without a :user_id" do
    @user_event.user_id = nil
    @user_event.should_not_be_valid
    @user_event.errors.full_messages.should_include "User can't be blank"
  end
  
  specify "should be valid with a :user_id" do
    @user_event.should_be_valid
  end
end