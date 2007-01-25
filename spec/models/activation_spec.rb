require File.dirname(__FILE__) + '/../spec_helper'

context "A new Activation" do
  fixtures :users, :events

  setup do
    @activation = Activation.new :signup_id => 2, :signup_key => 'e3907e189595061ac246459ede9600d8' # begin valid
  end
  
  specify "should send user.activate! on create" do
    @activation.valid? # to load user
    @activation.user.should_receive(:activate!).with(@activation)
    @activation.save
  end
end