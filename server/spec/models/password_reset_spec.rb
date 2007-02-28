require File.dirname(__FILE__) + '/../spec_helper'

context "The PasswordReset class" do
  specify "should have event_key :request" do
    [:request, :request=, :request_id, :request_id=, :request_key, :request_key=].each do |m|
      PasswordReset.instance_methods.should_include m.to_s
    end
  end
end

context "A PasswordReset (in general)" do
  fixtures :events, :users
  
  setup do
    @event = PasswordReset.new
  end
  
  specify "should load :user on demand from :request" do
    @event.user.should_be nil
    @event.request = events(:password_reset_request_fred)
    @event.user.should_be == users(:fred)
  end
  
  specify "should delegate :password and :password_confirmation (getter and setter) to :user" do
    @event.request = events(:password_reset_request_fred) # allow load user
    (@event.password = 'foo').should == @event.user.password
    (@event.user.password = 'foo').should == @event.password
    (@event.password_confirmation = 'foo').should == @event.user.password_confirmation
    (@event.user.password_confirmation = 'foo').should == @event.password_confirmation
  end
end

context "A new PasswordReset" do
  fixtures :users, :events, :event_properties

  setup do
    @event = PasswordReset.new :request_id => 4, :request_key => '34a350336e79e39e2d3244cee34f791c', :password => 'foobar' # begin with a valid PasswordReset
  end
  
  specify "should be invalid when :request is nil" do 
    @event.request_id = 666
    @event.should_not_be_valid
    @event.errors.full_messages.should_include "Request is not valid"
  end
  
  specify "should be invalid when :request is a new record" do
    @event.request = PasswordResetRequest.new
    @event.should_not_be_valid
    @event.errors.full_messages.should_include "Request is not valid"
  end
  
  specify "should be invalid without a valid :user" do
    @event.user = User.new
    @event.should_not_be_valid
    @event.errors.full_messages.should_include "User is invalid"
  end
  
  specify "should merge inavlid user errors into errors" do
    @event.attributes = {:password => 'gunk', :password_confirmation => '8908989089080'}
    @event.should_not_be_valid
    @event.errors.full_messages.to_set.should == @event.user.errors.full_messages.to_set << 'User is invalid'
  end
  
  specify "should be valid with saved request" do
    @event.should_be_valid
  end
  
  specify "should change user's password on create" do
    @event.save
    User.find_by_email(@event.user.email).authenticate_password('foobar').should == true
  end
end