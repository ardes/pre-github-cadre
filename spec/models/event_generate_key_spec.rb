require File.dirname(__FILE__) + '/../spec_helper'

class EventWithGenerateKey < Event
  include Event::GenerateKey
end

context "An Event class with GenerateKey mixin" do
  fixtures :event_properties

  specify "has the class-wide key_algorithm attribute" do
    EventWithGenerateKey.key_algorithm.should == 'sha1' # event_properties is empty - so this will be the default value
  end
  
  specify "allows setting the class-wide key_algorithm (with key_algorithm=)" do
    EventWithGenerateKey.key_algorithm = 'md5'
    EventWithGenerateKey.key_algorithm.should == 'md5'
  end
  
  specify "raises ArgumentError when setting key_algorithm with unsupported algorithm" do
    lambda{ EventWithGenerateKey.key_algorithm = 'foo' }.should_raise ArgumentError
  end
end

context "A new Event with GenerateKey mixin" do
  fixtures :event_properties
  
  setup do
    @event = EventWithGenerateKey.new
  end
  
  specify "should generate a key and key_hash on create" do
    @event.save
    @event.key.should_be_kind_of(String)
    @event.key_hash.should_be_kind_of(String)
  end
end

context "An existing Event with GenerateKey mixin" do
  fixtures :event_properties
  
  setup do
    @event = EventWithGenerateKey.create
    @key = @event.key
    @event = EventWithGenerateKey.find(@event.id) # reload from db
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
    EventWithGenerateKey.find_by_id_and_key_hash(@event.id, @event.key_hash).should == @event
  end
  
  specify "should be findable with class find_by_id_and_key" do
    EventWithGenerateKey.find_by_id_and_key(@event.id, @key).should == @event
  end
end

