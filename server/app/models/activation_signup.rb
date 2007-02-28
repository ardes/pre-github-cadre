class ActivationSignup < Signup
  attr_accessor_with_default :send_email, false
  
  after_create do |signup|
    activation = Activation.new
    activation.signup = signup
    activation.save!
  end
  
  # catch any problems with the after_create of activation
  def save(*args)
    super(*args)
  rescue ActiveRecord::RecordInvalid => invalid_activation
    errors.add_to_base("Activation is not valid")
    false
  end
end