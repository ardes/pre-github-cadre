class CadreNotifier < ActionMailer::Base
  include ActionController::UrlWriter
  default_url_options[:host] = CADRE_HOST
  
  def signed_up(signup, sent_at = Time.now)
    apply_default_options(sent_at)
    @subject        = "[#{CADRE_NAME}] Please activate your new account"
    @recipients     = signup.user.email_address
    @body[:signup]  = signup
    @body[:user]    = signup.user
  end
  
  def activated(activation, sent_at = Time.now)
    apply_default_options(sent_at)
    @subject            = "[#{CADRE_NAME}] Welcome to your account"
    @recipients         = activation.user.email_address
    @body[:activation]  = activation
    @body[:user]        = activation.user
  end
  
  def requested_reset_password(request, sent_at = Time.now)
    apply_default_options(sent_at)
    @subject        = "[#{CADRE_NAME}] Request to reset your password"
    @recipients     = request.user.email_address
    @body[:request] = request
    @body[:user]    = request.user
  end
  
  def reset_password(reset, sent_at = Time.now)
    apply_default_options(sent_at)
    @subject      = "[#{CADRE_NAME}] Your password was reset"
    @recipients   = reset.user.email_address
    @body[:reset] = reset
    @body[:user]  = reset.user
  end
  
protected
  def apply_default_options(sent_at)
    @from     = CADRE_FROM
    @sent_on  = sent_at
    @headers  ||= {}
    @body     ||= {}
    @body     = {:cadre_name => CADRE_NAME, :cadre_home => CADRE_HOME}
  end
end
