require File.dirname(__FILE__) + '/../spec_helper'

context "SignupNotifier: activate_your_account" do
  fixtures :events, :users
  include MailerSpecHelper
  
  setup do
    @signup = events(:signup_joe)
    @signup.should_receive(:key).any_number_of_times.and_return('e3907e189595061ac246459ede9600d8')
    @signup_notifier = SignupNotifier.create_activate_your_account(@signup)
  end
  
  specify "should set @to to user's email address" do
    @signup_notifier.to.should == ["joe@bloggs.com"]
  end
  
  specify "should set @subject to 'Please activate your new CADRE account'" do
    @signup_notifier.subject.should == "Please activate your new #{CADRE_NAME} account"
  end
  
  specify "should set @from to CADRE_FROM" do
    @signup_notifier.from.should_eql [CADRE_FROM]
  end
  
  specify "should contain user activation url in mail body" do
    activate_url = new_activation_url :host => CADRE_HOST, :signup_id => @signup.id, :signup_key => @signup.key
    @signup_notifier.body.should_include activate_url
  end
  
  specify "should contain user flase signup url in mail body" do
    false_signup_url = new_false_signup_url :host => CADRE_HOST, :signup_id => @signup.id, :signup_key => @signup.key
    @signup_notifier.body.should_include false_signup_url
  end
end

context "SignupNotifier" do
  include MailerSpecHelper
  
  setup do
    setup_mailer
  end

  specify "should deliver activate_your_account on create Signup" do
    @signup = Signup.create :email => 'gumby@play.com', :password => 'rubber'
    @queue.last.to.should == ['gumby@play.com']
    @signup.user.destroy
    @signup.destroy
  end
  
  specify "should not deliver activate_your_account when Signup create fails" do
    @signup = Signup.create :email => 'gumby@play.com', :password => 'rubber', :password_confirmation => 'ducky'
    @queue.length.should_be 0
  end
  
end