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