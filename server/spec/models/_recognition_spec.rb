require File.dirname(__FILE__) + '/../spec_helper'

context "A new Recognition" do
  fixtures :events, :users
  
  setup do
    @login = Login.create :email => 'fred@gmail.com', :password => 'wilma'
    @recognition = Recognition.new :login_id => @login.id, :login_key => @login.key # start with a valid Recognition
  end
  
  specify "should be valid with a valid login" do
    @recognition.should_be_valid
  end
  
  specify "should have user == to login's user on create" do
    @recognition.save.should_be true
    @recognition.user.should_be == @login.user
  end
end