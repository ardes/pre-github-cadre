require File.dirname(__FILE__) + '/../spec_helper'

context "The Signup class" do
  specify "should have GenerateKey mixin" do
    Signup.included_modules.should_include Event::GenerateKey
  end
end

context "A new Signup" do
  fixtures :users, :events, :event_properties

  setup do
    @signup = Signup.new 'email' => 'satan@hell.com', :password => 'kittens' # begin with a valild signup
  end
  
  specify "should build :user on demand" do
    @signup.user.should_be_kind_of User
  end
  
  specify "should delegate :email, :email_confirmation, :display_name, :password and :password_confirmation (getter and setter) to :user" do
    delegate_methods = [:email, :email_confirmation, :display_name, :password, :password_confirmation]
    delegate_methods.each do |m|
      random_string = (1..10).inject('') {|s,_| s << ('a'..'z').to_a[rand(26)]}
      @signup.send "#{m}=", random_string
      @signup.user.send(m).should == random_string
      @signup.send(m).should == random_string
    end
  end
    
  specify "should be invalid without a valid :user" do
    @signup.user = User.new
    @signup.should_not_be_valid
  end
  
  specify "should merge inavlid user errors into errors" do
    @signup.attributes = {:password => 'gunk', :email => 'jkljkljkjkjkl', :email_confirmation => '8908989089080'}
    @signup.should_not_be_valid
    @signup.errors.full_messages.to_set.should == @signup.user.errors.full_messages.to_set << 'User is invalid'
  end
end