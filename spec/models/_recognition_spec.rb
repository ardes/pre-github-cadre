require File.dirname(__FILE__) + '/../spec_helper'

context "A new Recognition" do
  fixtures :events, :users
  
  setup do
    @recognition = Recognition.new :user_id => 1 # start with a valid Recognition (user:1 is activated)
  end

  specify "should unprotect :user_id (and allow setting user_id via attributes)" do
    @recognition.user_id.should == 1
  end
  
  specify "should be invalid with a non activated user" do
    @recognition = Recognition.new :user_id => 2 # user:2 is not activated
    @recognition.should_not_be_valid
    @recognition.errors.full_messages.should_include "User should be activated"
  end
  
  specify "should be valid with an activated user" do
    @recognition.should_be_valid
  end
end