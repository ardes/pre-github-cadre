require File.dirname(__FILE__) + '/../spec_helper'

module UserNotifierSpecHelper
  def self.included(base)
    base.class_eval do
      fixtures :events, :users
      include ActionController::UrlWriter
      default_url_options[:host] = CADRE_HOST
    end
  end
end

context "UserNotifier" do
  include UserNotifierSpecHelper
  
  specify "should deliver activate_your_account(signup) on create Signup" do
    UserNotifier.should_receive(:deliver_activate_your_account) {|signup| signup.email.should_be == 'gumby@play.com' }
    Signup.create :email => 'gumby@play.com', :password => 'rubber'
  end
  
  specify "should not deliver activate_your_account when Signup create fails" do
    UserNotifier.should_not_receive :deliver_activate_your_account
    Signup.create :email => 'gumby@play.com', :password => 'rubber', :password_confirmation => 'ducky'
  end

  specify "should deliver welcome_to_cadre(user) on create Activation" do
    UserNotifier.should_receive(:deliver_welcome_to_cadre) {|user| user.should_be == users(:joe) }
    activation = Activation.new
    activation.signup = events(:signup_joe)
    activation.save
  end

  specify "should not deliver welcome_to_cadre when create Activation fails" do
    UserNotifier.should_not_receive :deliver_activate_your_account
    activation = Activation.new
    activation.signup = events(:signup_fred) # fred is already activated
    activation.save
  end
end

context "UserNotifier: activate_your_account(signup[, sent_at])" do
  include UserNotifierSpecHelper
  
  setup do
    @signup = events(:signup_joe)
    @signup.should_receive(:key).any_number_of_times.and_return('e3907e189595061ac246459ede9600d8')
    @mail = UserNotifier.create_activate_your_account(@signup)
  end
  
  specify "should have date == sent_at argument if supplied" do
    sent_at = Time.now - 1.month
    @mail = UserNotifier.create_activate_your_account(@signup, sent_at)
    @mail.date == sent_at
  end  
  
  specify "should have to == user's email" do
    @mail.to.should == ["joe@bloggs.com"]
  end
  
  specify "should have subject == '[CADRE_NAME] Please activate your new account'" do
    @mail.subject.should == "[#{CADRE_NAME}] Please activate your new account"
  end
  
  specify "should have from == CADRE_FROM" do
    @mail.from.should == [CADRE_FROM]
  end
  
  specify "should contain user activate url in mail body" do
    @mail.body.should_include activate_url(:signup_id => @signup.id, :signup_key => @signup.key)
  end
  
  specify "should contain cancel_signup url in mail body" do
    @mail.body.should_include cancel_signup_url(:signup_id => @signup.id, :signup_key => @signup.key)
  end
end

context "UserNotifier: welcome_to_cadre(user[, sent_at])" do
  include UserNotifierSpecHelper
  
  setup do
    @user = users(:joe)
    @mail = UserNotifier.create_welcome_to_cadre(@user)
  end
  
  specify "should have date == sent_at argument if supplied" do
    sent_at = Time.now - 1.month
    @mail = UserNotifier.create_welcome_to_cadre(@user, sent_at)
    @mail.date == sent_at
  end  
  
  specify "should have to == user's email" do
    @mail.to.should == ["joe@bloggs.com"]
  end
  
  specify "should have subject == '[CADRE_NAME] Welcome to your account'" do
    @mail.subject.should == "[#{CADRE_NAME}] Welcome to your account"
  end
  
  specify "should have from == CADRE_FROM" do
    @mail.from.should == [CADRE_FROM]
  end
  
  specify "should contain forgot_password url in mail body" do
    @mail.body.should_include request_reset_password_url(:user_id => @user.id)
  end
  
  specify "should contain edit_account url in mail body" do
    @mail.body.should_include edit_account_url
  end
end