require File.dirname(__FILE__) + '/../spec_helper'

context "The Signup class" do
  specify "should have Cadre::KeyEvent::Generate mixin" do
    Signup.included_modules.should_include Cadre::KeyEvent::Generate
  end
end

context "A Signup (in general)" do
  specify "should allow setting :send_email via attributes" do
    Signup.new(:send_email => false).should_not_send_email
  end
end

context "A new Signup" do
  fixtures :users, :events, :event_properties

  setup do
    @signup = Signup.new :email => 'satan@hell.com', :password => 'kittens' # begin with a valild signup
  end
  
  specify "should build :user on demand" do
    @signup.user.should_be_kind_of User
  end
  
  specify "should delegate :email, :email_confirmation, :display_name, :password and :password_confirmation (getter and setter) to :user" do
    delegate_methods = [:email, :email_confirmation, :display_name, :password, :password_confirmation]
    delegate_methods.each do |m|
      @signup.send "#{m}=", 'foo'
      @signup.user.send(m).should == 'foo'
      @signup.send(m).should == 'foo'
    end
  end
    
  specify "should be invalid without a valid :user" do
    @signup.user = User.new
    @signup.should_not_be_valid
    @signup.errors.full_messages.should_include "User is invalid"
  end
  
  specify "should merge inavlid user errors into errors" do
    @signup.attributes = {:password => 'gunk', :email => 'jkljkljkjkjkl', :email_confirmation => '8908989089080'}
    @signup.should_not_be_valid
    @signup.errors.full_messages.to_set.should == @signup.user.errors.full_messages.to_set << 'User is invalid'
  end
  
  specify "should default to :send_email == true" do
    @signup.should_send_email
  end
end