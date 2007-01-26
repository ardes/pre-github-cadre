require File.dirname(__FILE__) + '/../spec_helper'
require RAILS_ROOT + "/spec/fixtures/my_key_event"

context "An Event with Event::KeyEvent mixin" do
  fixtures :event_properties

  specify "has the class-wide key_algorithm attribute" do
    MyKeyEvent.key_algorithm.should == 'sha1' # event_properties is empty - so this will be the default value
  end
  
  specify "allows setting the class-wide key_algorithm (with key_algorithm=)" do
    MyKeyEvent.key_algorithm = 'md5'
    MyKeyEvent.key_algorithm.should == 'md5'
  end
  
  specify "raises ArgumentError when setting key_algorithm with unsupported algorithm" do
    lambda{ MyKeyEvent.key_algorithm = 'foo' }.should_raise ArgumentError
  end
end

context "A new object with Event::KeyEvent mixin" do
  fixtures :event_properties
  
  setup do
    @event = MyKeyEvent.new
  end
  
  specify "should generate a key and key_hash on create" do
    @event.save
    @event.key.should_be_kind_of(String)
    @event.key_hash.should_be_kind_of(String)
  end
end

context "An existing event with Event::KeyEvent mixin" do
  fixtures :event_properties
  
  setup do
    @event = MyKeyEvent.create
    @key = @event.key
    @event = MyKeyEvent.find(@event.id) # reload from db
  end
  
  specify "should not have a key" do
    @event.key.should == nil
  end

  specify "should have a key_hash" do
    @event.key_hash.should_be_kind_of(String)
  end
  
  specify "should match_key_hash with correct key" do
    @event.should_match_key_hash(@key)
  end

  specify "should not match_key_hash with incorrect key" do
    @event.should_not_match_key_hash(@key + 'foo')
  end
  
  specify "should be findable with class find_by_id_and_key_hash" do
    MyKeyEvent.find_by_id_and_key_hash(@event.id, @event.key_hash).should == @event
  end
  
  specify "should be findable with class find_by_id_and_key" do
    MyKeyEvent.find_by_id_and_key(@event.id, @key).should == @event
  end
end

