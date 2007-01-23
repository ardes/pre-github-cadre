require File.dirname(__FILE__) + '/../spec_helper'

context "A new Activation" do
  fixtures :users, :events

  setup do
    @activation = Activation.new :signup_id => 2, :signup_key => 'e3907e189595061ac246459ede9600d8' # begin with a valid signup
  end
  
  specify "should update activation_id in associated user on create" do
    @activation.signup.user.activation_id.should == nil
    @activation.save.should == true
    @activation.user.activation_id.should == @activation.id
  end
end