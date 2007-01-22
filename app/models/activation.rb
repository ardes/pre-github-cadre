class Activation < UserEvent
  attr_accessor :signup
  
  validate_on_create do |activation|
    activation.errors.add(:signup, "is not an existing record") unless activation.signup.is_a?(Signup) && !activation.signup.new_record?
  end
  
  before_create do |activation|
    activation.user_id = activation.signup.user_id
  end
  
  # User belongs_to Activation, for performance reasons (searching for active users).
  # Because of this, we update the activation_id fk in the user after create.
  after_create do |activation| 
    activation.user.update_attribute :activation_id, activation.id
  end
end