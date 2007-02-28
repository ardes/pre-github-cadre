class Recognition < ActivatedUserEvent
  has_key_event :login
  
  before_validation do |recognition|
    recognition.user = recognition.login.user rescue nil
  end
end