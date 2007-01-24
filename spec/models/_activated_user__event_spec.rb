require File.dirname(__FILE__) + '/../spec_helper'

context "A new ActivatedUserEvent (and subclasses)" do
  fixtures :events, :users
  
  setup do
    @event = ActivatedUserEvent.new
    @event.user_id = 1 # start with a valid ActivatedUserEvent (user:1 is activated)
  end

  specify "should be invalid without an activated user" do
    @event.user_id = 2 # user:2 in not activated
    @event.should_not_be_valid
    @event.errors.full_messages.should_include "User should be activated"
  end
  
  specify "should be valid with an activated user" do
    @event.should_be_valid
  end
end