class PasswordReset < ActivatedUserEvent
  attr_protected :request
  attr_accessor :request, :request_id, :request_key
  
  def request
    @request ||= (PasswordResetRequest.find_by_id_and_key(request_id, request_key) rescue nil)
  end
    
  before_validation do |reset|
    reset.user = reset.request.user if reset.request
  end
  
  validate_on_create do |reset|
    reset.errors.add(:request, "is not valid") unless reset.request.is_a?(PasswordResetRequest) && !reset.request.new_record?
  end
  
  after_create do |reset|
    reset.user.reset_password!
  end
end