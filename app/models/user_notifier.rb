class UserNotifier < ActionMailer::Base
  include ActionController::UrlWriter
  default_url_options[:host] = CADRE_HOST
  
  def activate_your_account(signup, sent_at = Time.now)
    apply_default_options(sent_at)
    @subject        = "[#{CADRE_NAME}] Please activate your new account"
    @recipients     = signup.user.email_address
    @body[:signup]  = signup
    @body[:user]    = signup.user
  end
  
  def welcome_to_cadre(user, sent_at = Time.now)
    apply_default_options(sent_at)
    @subject      = "[#{CADRE_NAME}] Welcome to your account"
    @recipients   = user.email_address
    @body[:user]  = user
  end
  
protected
  def apply_default_options(sent_at)
    @from = CADRE_FROM
    @sent_on = sent_at
    @body ||= {}
    @body = {:cadre_name => CADRE_NAME, :cadre_home => CADRE_HOME}
    @headers = {}
  end
end
