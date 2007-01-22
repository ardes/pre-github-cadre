class Activation < WithSignupEvent  
  # User belongs_to Activation, for performance reasons (searching for active users).
  # Because of this, we update the activation_id fk in the user after create.
  after_create do |activation| 
    activation.user.update_attribute :activation_id, activation.id
  end
end