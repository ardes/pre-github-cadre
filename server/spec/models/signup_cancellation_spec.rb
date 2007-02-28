require File.dirname(__FILE__) + '/../spec_helper'

context "A new SignupCancellation" do
  fixtures :users, :events

  setup do
    @cancel = SignupCancellation.new :signup_id => 2, :signup_key => 'e3907e189595061ac246459ede9600d8' # begin with a valid signup
  end
  
  specify "should destroy (non-activated) associated user on create" do
    @cancel.save.should == true
    @cancel.user.should_be_frozen
    lambda{ User.find(@cancel.user_id) }.should_raise ActiveRecord::RecordNotFound
  end
  
  specify "should be uncreatable when user is activated" do
    @cancel.signup.user.activation_id = 1
    @cancel.save.should == false
    @cancel.user.should_not_be_frozen
    lambda{ User.find(@cancel.user_id) }.should_not_raise ActiveRecord::RecordNotFound
  end
end