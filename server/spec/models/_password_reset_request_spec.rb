require File.dirname(__FILE__) + '/../spec_helper'

context "The PasswordResetRequest class" do
  specify "should have Cadre::KeyEvent::Generate mixin" do
    PasswordResetRequest.included_modules.should_include Cadre::KeyEvent::Generate
  end
end

context "A new PasswordResetRequest (and subclasses)" do
  fixtures :events, :users
  
  setup do
    @request = PasswordResetRequest.new :email => users(:fred).email # start with a valid ActivatedUserEvent (user:fred is activated)
  end
  
  specify "should be valid with an activated user's email" do
    @request.should_be_valid
  end
  
  specify "should be invalid without an email" do
    @request.email = nil
    @request.should_not_be_valid
    @request.errors.full_messages.should_include "Email can't be blank"
  end
  
  specify "should be invalid without a user's email" do
    @request.email = 'blurg'
    @request.should_not_be_valid
    @request.errors.full_messages.should_include 'Email is not recognised'
  end
  
  specify "should be invalid without an activated user's email" do
    @request.email = users(:joe).email
    @request.should_not_be_valid
    @request.errors.full_messages.should_include 'User should be activated'
  end
end