require File.dirname(__FILE__) + '/../spec_helper'

module CadreNotifierSpecHelper
  def self.included(base)
    base.class_eval do
      fixtures :events, :users, :user_properties, :event_properties
      include ActionController::UrlWriter
      default_url_options[:host] = CADRE_HOST
    end
  end
end

context "CadreNotifier" do
  include CadreNotifierSpecHelper
  
  specify "should deliver signed_up(signup) on create Signup" do
    CadreNotifier.should_receive(:deliver_signed_up) {|signup| signup.email.should_be == 'gumby@play.com' }
    Signup.create :email => 'gumby@play.com', :password => 'rubber'
  end

  specify "should not deliver signed_up(signup) on create Signup with :send_email => false" do
    CadreNotifier.should_not_receive(:deliver_signed_up)
    Signup.create :email => 'gumby@play.com', :password => 'rubber', :send_email => false
  end

  specify "should deliver activated(user) on create Activation" do
    CadreNotifier.should_receive(:deliver_activated) {|activation| activation.user.should_be == users(:joe) }
    activation = Activation.new
    activation.signup = events(:signup_joe)
    activation.save
  end
  
  specify "should deliver requested_reset_password(request) on create PasswordResetRequest" do
    CadreNotifier.should_receive(:deliver_requested_reset_password) {|request| request.user.should_be == users(:fred)}
    PasswordResetRequest.create :user_id => users(:fred).id
  end
  
  specify "should deliver reset_password(reset) on create PasswordReset" do
    CadreNotifier.should_receive(:deliver_reset_password) {|reset| reset.user.should_be == users(:fred)}
    request = PasswordResetRequest.create :user_id => users(:fred).id
    PasswordReset.create :request_id => request.id, :request_key => request.key, :password => 'foobar'
  end
end

context "CadreNotifier: signed_up(signup[, sent_at])" do
  include CadreNotifierSpecHelper
  
  setup do
    @signup = events(:signup_joe)
    @signup.should_receive(:key).any_number_of_times.and_return('e3907e189595061ac246459ede9600d8')
    @mail = CadreNotifier.create_signed_up(@signup)
  end
  
  specify "should have date == sent_at argument if supplied" do
    sent_at = Time.now - 1.month
    @mail = CadreNotifier.create_signed_up(@signup, sent_at)
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

context "CadreNotifier: activated(activation[, sent_at])" do
  include CadreNotifierSpecHelper
  
  setup do
    @activation = events(:activation_fred)
    @mail = CadreNotifier.create_activated(@activation)
  end
  
  specify "should have date == sent_at argument if supplied" do
    sent_at = Time.now - 1.month
    @mail = CadreNotifier.create_activated(@activation, sent_at)
    @mail.date == sent_at
  end  
  
  specify "should have to == user's email" do
    @mail.to.should == ["fred@gmail.com"]
  end
  
  specify "should have subject == '[CADRE_NAME] Welcome to your account'" do
    @mail.subject.should == "[#{CADRE_NAME}] Welcome to your account"
  end
  
  specify "should have from == CADRE_FROM" do
    @mail.from.should == [CADRE_FROM]
  end
  
  specify "should contain forgot_password url in mail body" do
    @mail.body.should_include request_reset_password_url(:user_id => @activation.user.id)
  end
  
  specify "should contain account url in mail body" do
    @mail.body.should_include account_url
  end
end

context "CadreNotifier: requested_reset_password(request[, sent_at])" do
  include CadreNotifierSpecHelper
  
  setup do
    @request = events(:password_reset_request_fred)
    @request.should_receive(:key).any_number_of_times.and_return('34a350336e79e39e2d3244cee34f791c')
    @mail = CadreNotifier.create_requested_reset_password(@request)
  end
  
  specify "should have date == sent_at argument if supplied" do
    sent_at = Time.now - 1.month
    @mail = CadreNotifier.create_requested_reset_password(@request, sent_at)
    @mail.date == sent_at
  end  
  
  specify "should have to == user's email" do
    @mail.to.should == ["fred@gmail.com"]
  end
  
  specify "should have subject == '[CADRE_NAME] Request to reset your password'" do
    @mail.subject.should == "[#{CADRE_NAME}] Request to reset your password"
  end
  
  specify "should have from == CADRE_FROM" do
    @mail.from.should == [CADRE_FROM]
  end
  
  specify "should contain reset_password url in mail body" do
    @mail.body.should_include reset_password_url(:request_id => @request.id, :request_key => @request.key)
  end
end

context "CadreNotifier: reset_password(reset[, sent_at])" do
  include CadreNotifierSpecHelper
  
  setup do
    @reset = PasswordReset.create :request_id => events(:password_reset_request_fred).id, :request_key => '34a350336e79e39e2d3244cee34f791c', :password => 'foobar'
    @mail = CadreNotifier.create_reset_password(@reset)
  end
  
  specify "should have date == sent_at argument if supplied" do
    sent_at = Time.now - 1.month
    @mail = CadreNotifier.create_reset_password(@reset, sent_at)
    @mail.date == sent_at
  end  
  
  specify "should have to == user's email" do
    @mail.to.should == ["fred@gmail.com"]
  end
  
  specify "should have subject == '[CADRE_NAME] Your password was reset'" do
    @mail.subject.should == "[#{CADRE_NAME}] Your password was reset"
  end
  
  specify "should have from == CADRE_FROM" do
    @mail.from.should == [CADRE_FROM]
  end
end