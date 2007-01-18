require File.dirname(__FILE__) + '/../spec_helper'

context "A User class" do
  fixtures :users, :user_properties

  specify "has the class-wide password_algorithm attribute" do
    User.password_algorithm.should == 'sha256'
  end
  
  specify "allows setting the class-wide password_algorithm (with password_algorithm=)" do
    User.password_algorithm = 'md5'
    User.password_algorithm.should == 'md5'
    User.password_algorithm = 'sha256'
  end
  
  specify "raises ArgumentError when setting password_algorithm with unsupported algorithm" do
    lambda{ User.password_algorithm = 'foo' }.should_raise ArgumentError
  end
end

context "A User (in general)" do
  fixtures :users, :user_properties

  setup do
    @user = users(:fred)
  end
  
  specify "should protect :password_hash, :password_salt and :password_algorithm from mass assignment" do
    @user.update_attributes :email => 'FRED@F.COM', :password_hash => '1', :password_salt => '2', :password_algorithm => '3'
    @user.reload
    @user.email.should == 'FRED@F.COM'
    @user.password_hash.should_not == '1'
    @user.password_salt.should_not == '2'
    @user.password_algorithm.should_not == '3'
    @user.authenticate_password('wilma').should == true
  end
end

context "A new User" do
  fixtures :users, :user_properties

  setup do
    @user = users(:fred).clone # start with a valid User
    @user.email = 'fred2@gmail.com'
  end
  
  specify "should be invalid without an :email" do
    @user.email = nil
    @user.should_not_be_valid
    @user.errors.full_messages.should == ["Email can't be blank"]
  end
  
  specify "should be invalid with a non unique :email" do
    @user.email = 'fred@gmail.com'
    @user.should_not_be_valid
    @user.errors.full_messages.should == ["Email has already been taken"]
  end
  
  specify "should be invalid without a matching :email_confirmation" do
    @user.attributes = {:email => 'foo@gmail.com', :email_confirmation => 'as'}
    @user.should_not_be_valid
    @user.errors.full_messages.should == ["Email doesn't match confirmation"]
  end
  
  specify  "should be invalid with short password (<5 chars)" do
    @user.password = 'tiny'
    @user.should_not_be_valid
    @user.errors.full_messages.should == ["Password is too short (minimum is 5 characters)"]
  end

  specify "should be invalid without a matching :password_confirmation" do
    @user.attributes = {:password => "Krazy!", :password_confirmation => 'NotKrazy!'}
    @user.should_not_be_valid
    @user.errors.full_messages.should == ["Password doesn't match confirmation"]
  end
end

context "A User with an old password_algorithm" do
  fixtures :users, :user_properties

  setup do
    User.password_algorithm = 'md5'
    @user = users(:fred)
  end
  
  specify "should be able to authenticate (using old algorithm)" do
    @user.authenticate_password('wilma').should == true
  end
  
  specify "should update password hash on authenticate with new algorithm" do
    @user.authenticate_password('wilma')
    @user.password.should == 'wilma'
    @user.password_algorithm.should == 'md5'
    @user.password_hash.should == SaltedHash.compute('md5', @user.password_salt, 'wilma')
  end
  
  specify "should update password hash on set_password with new algorithm" do
    @user.password = 'betty'
    @user.password.should == 'betty'
    @user.password_algorithm.should == 'md5'
    @user.password_hash.should == SaltedHash.compute('md5', @user.password_salt, 'betty')
  end

  teardown do
    User.password_algorithm = 'sha256'
  end
end