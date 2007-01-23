require File.dirname(__FILE__) + '/../spec_helper'

context "A new ActivatedUserEvent (and subclasses)" do
  fixtures :events
  
  setup do
    @user_event = ActivatedUserEvent.new
    @user_event.user_id = 1 # start with a valid ActivatedUserEvent (user:1 is activated)
  end

  specify "should be invalid without an activated user" do
    @user_event.user_id = 2 # user:2 in not activated
    @user_event.should_not_be_valid
    @user_event.errors.full_messages.should_include "User should be activated"
  end
  
  specify "should be valid with an activated user" do
    @user_event.should_be_valid
  end
end