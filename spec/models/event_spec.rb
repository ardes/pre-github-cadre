require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated event_spec.rb with fixtures loaded" do
  fixtures :events

  specify "fixtures should load two Events" do
    Event.should_have(2).records
  end

  specify "you should add more specs" do
    violated "not enough specs"
  end
end
