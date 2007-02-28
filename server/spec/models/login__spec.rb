require File.dirname(__FILE__) + '/../spec_helper'

context "The Login class" do
  specify "should have Cadre::KeyEvent::Generate mixin" do
    Signup.included_modules.should_include Cadre::KeyEvent::Generate
  end
end

context "A new Login" do
  fixtures :users, :events, :user_properties, :event_properties

  setup do
    @login = Login.new :email => 'fred@gmail.com', :password => 'wilma' # begin with a valid login
  end
  
  def login_should_not_authenticate
    @login.should_not_be_valid
    @login.errors.full_messages.should_include "User could not be authenticated"
  end
  
  specify "should be invalid without an email" do
    @login.email = nil
    @login.should_not_be_valid
    @login.errors.full_messages.should_include "Email can't be blank"
  end
  
  specify "should be invalid without a password" do
    @login.password = nil
    @login.should_not_be_valid
    @login.errors.full_messages.should_include "Password can't be blank"
  end

  specify "should be invalid (not authenticate) when email doesn't match any user" do
    @login.email = 'blerg'
    login_should_not_authenticate
  end
  
  specify "should be invalid (not authenticate) when user is not activated" do
    @login.attributes = {:email => 'joe@bloggs.com', :password => 'black'}
    login_should_not_authenticate
    @login.user.should_be == users(:joe)
  end
  
  specify "should be invalid (not authenticate) when password doesn't match" do
    @login.password = 'betty'
    login_should_not_authenticate
  end
  
  specify "should be valid when email and password match and use is activated" do
    @login.should_be_valid
  end
end