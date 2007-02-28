require File.dirname(__FILE__) + '/../spec_helper'

context "The User class" do
  fixtures :user_properties
  
  specify "has the class-wide password_algorithm attribute" do
    User.password_algorithm.should == 'sha1'
  end
  
  specify "allows setting the class-wide password_algorithm (with password_algorithm=)" do
    User.password_algorithm = 'md5'
    User.password_algorithm.should == 'md5'
  end
  
  specify "raises ArgumentError when setting password_algorithm with unsupported algorithm" do
    lambda{ User.password_algorithm = 'foo' }.should_raise ArgumentError
  end
  
  teardown do
    User.password_algorithm = 'sha1'
  end
end

context "A User (in general)" do
  setup do
    @user = User.new
  end
  
  specify "should protect :activation_id, :password_hash, :password_salt and :password_algorithm from mass assignment" do
    @user.attributes = {:activation_id => 666, :password_hash => '666', :password_salt => '666', :password_algorithm => '666'}
    @user.activation_id.should_not == 666
    @user.password_hash.should_not == '666'
    @user.password_salt.should_not == '666'
    @user.password_algorithm.should_not == '666'
  end
  
  specify "should derive :name from :display_name or :email" do
    @user.name.should_be_nil
    @user.email = 'frank@gmail.com'
    @user.name.should == 'Frank'
    @user.display_name = 'Frank Drebbin'
    @user.name.should == 'Frank Drebbin'
  end
  
  specify "should derive :email_address in format: ':name <:email>', if email present" do
    @user.email_address.should_be_nil
    @user.email = 'frank_d_drebbin@airplane.com'
    @user.email_address.should == 'Frank D Drebbin <frank_d_drebbin@airplane.com>'
    @user.attributes = {:display_name => 'Johnny', :email => 'john@gmail.com'}
    @user.email_address.should == 'Johnny <john@gmail.com>'
  end
  
  specify "should be activated? if activation_id is not nil" do
    @user.should_not_be_activated
    @user.activation_id = 1
    @user.should_be_activated
  end
  
  specify "should delegate created_at to signup if it exists" do
    @user.created_at.should == nil
    @user.signup = Signup.new
    @user.signup.created_at = time = Time.now
    @user.created_at.should == time
  end
  
  specify "should have a description containing name, email and activation status, if email present" do
    @user.description.should == nil
    @user.email = 'foo@bar.com'
    @user.description.should == 'Foo, foo@bar.com, not activated'
    @user.activation_id = 1
    @user.description.should == 'Foo, foo@bar.com, activated'
  end
end

context "A User being activated - with user.activate!(activation)" do
  fixtures :users, :events
  
  setup do
    @user = users(:joe)
  end

  specify "should succeed with a saved activation for that user, and set user.activation_id" do
    activation = Activation.new
    activation.signup = events(:signup_joe)
    activation.save
    @user.activate!(activation).should_be true
    User.find(@user.id).activation_id.should == activation.id
  end
  
  specify "should raise ArgumentError if activation is not for that user" do
    lambda{ @user.activate!(events(:activation_fred)) }.should_raise ArgumentError, "activation's user must be this user"
  end
  
  specify "should raise ArgumentError if activation is not a saved Activation" do
    lambda{ @user.activate!(Event.new) }.should_raise ArgumentError, "activation must be a saved Activation"
    lambda{ @user.activate!(Activation.new) }.should_raise ArgumentError, "activation must be a saved Activation"
  end
end

context "A new User" do
  fixtures :user_properties, :users

  setup do
    @user = User.new :email => 'barney@gmail.com', :password => 'betty' # start with a valid User
  end
  
  specify "should be invalid without an :email" do
    @user.email = nil
    @user.should_not_be_valid
    @user.errors.full_messages.should_include "Email can't be blank"
  end
  
  specify "should be invalid with a non unique :email" do
    @user.email = 'fred@gmail.com'
    @user.should_not_be_valid
    @user.errors.full_messages.should_include "Email has already been taken"
  end
  
  specify "should be invalid without a matching :email_confirmation, if it is supplied" do
    @user.email_confirmation = 'not_barney@gmail.com'
    @user.should_not_be_valid
    @user.errors.full_messages.should_include "Email doesn't match confirmation"
  end
  
  specify "should be invalid without a password" do
    @user.password = nil
    @user.should_not_be_valid
    @user.errors.full_messages.should_include "Password can't be blank"
  end
  
  specify "should be invalid with short password (<5 chars)" do
    @user.password = 'tiny'
    @user.should_not_be_valid
    @user.errors.full_messages.should_include "Password is too short (minimum is 5 characters)"
  end

  specify "should be invalid without a matching :password_confirmation, if it is supplied" do
    @user.password_confirmation = 'not_betty'
    @user.should_not_be_valid
    @user.errors.full_messages.should_include "Password doesn't match confirmation"
  end
  
  specify "should be valid with an :email and :password" do
    @user.should_be_valid
  end

  specify "should be valid with an :email and :password and matching :email_confirmation, and :password_confirmation, if they are supplied" do
    @user.password_confirmation = 'betty'
    @user.email_confirmation = 'barney@gmail.com'
    @user.should_be_valid
  end
end

context "A User updating their details" do
  fixtures :users, :user_properties

  setup do
    @user = users(:fred)
  end

  specify "should not update password if it is not supplied" do
    @user.save
    @user.should_match_password_hash('wilma')
  end
  
  specify "should have email_confirmation == email, unless it is written to" do
    @user.email_confirmation.should == @user.email
    @user.email_confirmation = ''
    @user.email_confirmation.should_not == @user.email
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
    @user.password_algorithm.should == 'md5'
    @user.password_hash.should == SaltedHash.compute('md5', 'wilma', @user.password_salt)
  end
  
  specify "should update password hash on hash_password with new algorithm" do
    @user.hash_password 'betty'
    @user.password_algorithm.should == 'md5'
    @user.password_hash.should == SaltedHash.compute('md5', 'betty', @user.password_salt)
  end

  teardown do
    User.password_algorithm = 'sha256'
  end
end