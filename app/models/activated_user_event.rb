class ActivatedUserEvent < UserEvent
  validates_each :user_id, :allow_nil => true do |event,_,_|
    event.errors.add(:user, 'should be activated') unless event.user.activated?
  end
end