class SignupNotifier < ActionMailer::Base
  include ActionController::UrlWriter
  
  def activate_your_account(signup, sent_at = Time.now)
    @subject = "Please activate your new #{CADRE_NAME} account"
    @recipients = signup.user.email_address
    @from = CADRE_FROM
    @sent_on = sent_at
    @headers = {}
    @body = {:signup => signup,
      :activation_url   => new_activation_url(:host => CADRE_HOST, :signup_id => signup.id, :signup_key => signup.key),
      :false_signup_url => new_false_signup_url(:host => CADRE_HOST, :signup_id => signup.id, :signup_key => signup.key)}
  end
end
