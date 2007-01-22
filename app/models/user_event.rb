class UserEvent < Event
  validates_presence_of :user_id
end