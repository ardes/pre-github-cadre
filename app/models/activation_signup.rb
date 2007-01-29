class ActivationSignup < Signup
  attr_accessor_with_default :send_email, false
  
  after_create do |signup|
    activation = Activation.new
    activation.signup = signup
    activation.save!
  end
end