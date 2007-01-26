require File.dirname(__FILE__) + '/../spec_helper'

context "The PasswordResetRequest class" do
  specify "should have KeyEvent::Generate mixin" do
    PasswordResetRequest.included_modules.should_include KeyEvent::Generate
  end
end

context "A new PasswordResetRequest (and subclasses)" do
  fixtures :events
  
  setup do
    @request = PasswordResetRequest.new :user_id => 1 # start with a valid ActivatedUserEvent (user:1 is activated)
  end

  specify "should unprotect :user_id (and allow setting user_id via attributes)" do
    @request.user_id.should == 1
  end
end