class Activation < NonActivatedUserEvent  
  after_create do |activation|
    Notifier.deliver_activated(activation) if activation.user.activate!(activation)
  end
end