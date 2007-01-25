require File.dirname(__FILE__) + '/../spec_helper'

context "an Event (and subclasses) in general" do
  setup do
    @event = Event.new
  end
  
  specify "should protect :user_id, and :created_at from mass assignment" do
    @event.attributes = {:user_id => 666, :created_at => 'The dawn of time'}
    @event.user_id.should_be_nil
    @event.created_at.should_be_nil
  end
end

context "A new Event (and subclasses)" do
  setup do
    @event = Event.new
  end

  specify "should be invalid with a badly formed :ip_address" do
    @event.ip_address = '666.666.666.666'
    @event.should_not_be_valid
    @event.errors.full_messages.should_include "Ip address is invalid"
  end
  
  specify "should be valid with an :ip_address if supplied" do
    @event.ip_address = '126.127.187.2'
    @event.should_be_valid
  end
  
  specify "should become readonly after create" do
    @event.save
    @event.should_be_readonly
  end
  
  specify "should have :created_at after create" do
    @event.save
    @event.created_at.should_be_kind_of(Time)
  end
  
  specify "should return false from saved?(klass) irrespective of klass" do
    @event.should_not_be_saved
    @event.should_not_be_saved Event
    @event.should_not_be_saved Signup
  end
end

context "An existing Event (and subclasses)" do
  fixtures :events
  
  setup do
    @event = events(:signup_fred)
  end
  
  specify "should be readonly" do
    @event.should_be_readonly
  end
  
  specify "should belong_to a :user" do
    @event.user.should_be_kind_of(User)
  end
  
  specify "should return true from saved?(klass) if a descendent of klass" do
    @event.should_be_saved
    @event.should_be_saved Event
    @event.should_be_saved Signup
    @event.should_not_be_saved Activation
  end
end
