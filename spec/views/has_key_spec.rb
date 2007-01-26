require File.dirname(__FILE__) + '/../spec_helper'
require RAILS_ROOT + '/spec/fixtures/has_key_event'

context "An event with Event::HasKeyEvent mixin (in general)" do
  setup do
    @event = HasKeyEvent.new
    @key_event = KeyEvent.create
  end
  
  specify "loads :key_event from :key_event_id and :key_event_key, if there is a matching KeyEvent" do
    @event.key_event.should_be_nil
    @event.key_event_id = @key_event.id
    @event.key_event.should_be_nil
    @event.key_event_key = @key_event.key
    @event.key_event.should == @key_event
  end
  
  specify "should protect :key_event from mass assignment" do
    @event.attributes = {:key_event => 'foo'}
    @event.key_event.should_be_nil
  end
  
  specify "should allow setting of :key_event directly" do
    @event.key_event = 'foo'
    @event.key_event.should == 'foo'
  end
  
  specify "should set :key_event_id and :key_event_key before other attributes" do
    @event.attributes = {:key_event_id => 1, :key_event_key => 'foo'}
    @event.attributes = {:log_key_event => 'foo', :key_event_id => 2, :key_event_key => 'bar'}
    @event.log_key_event.should == 'msg:foo id:2 key:bar' # set before :log_key_event, even though after in attrs hash
  end
  
  specify "should set :key_event_id and :key_event_key before other attributes, to enable key_event dependencies in attrs" do
    lambda{ @event.attributes = {:key_event_ip_address => 'foo'} }.should_raise ArgumentError, "key_event must be set"
    lambda{ @event.attributes = {:key_event_ip_address => 'foo', :key_event_id => @key_event.id, :key_event_key => @key_event.key} }.should_not_raise
    @event.key_event_ip_address.should == 'foo'
  end
end

context "A new Event::HasKeyEvent mixin" do
  setup do
    @key_event = KeyEvent.create
    @event = HasKeyEvent.new :key_event_id => @key_event.id, :key_event_key => @key_event.key # begin valid
  end
  
  specify "should be invalid when :key_event is nil or cannot be found" do 
    @event.key_event_id = 666
    @event.should_not_be_valid
    @event.errors.full_messages.should_include "Key event is not valid"
  end
  
  specify "should be invalid when :key_event is a new record" do
    @event.key_event = KeyEvent.new
    @event.should_not_be_valid
    @event.errors.full_messages.should_include "Key event is not valid"
  end
  
  specify "should be valid with existing key event" do
    @event.should_be_valid
  end
end