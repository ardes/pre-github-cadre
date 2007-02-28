require File.dirname(__FILE__) + '/../spec_helper'

context "A new ActivationSignup" do
  fixtures :users, :events, :event_properties

  setup do
    @signup = ActivationSignup.new 'email' => 'satan@hell.com', :password => 'kittens' # begin valid
  end
 
  specify "should create an Activation on create" do
    @signup.save.should_be true
    @signup.user.reload.should_be_activated
  end
  
  specify "should default to :send_email == false" do
    @signup.should_not_send_email
  end
end