require 'event/has_key'
require RAILS_ROOT + '/spec/fixtures/key_event'

class HasKeyEvent < Event
  include Event::HasKey
  
  has_key_event :key_event
  
  def key_event_ip_address=(arg)
    key_event.ip_address = arg
  rescue
    raise ArgumentError, "key_event must be set"
  end
  
  def key_event_ip_address
    key_event.ip_address
  rescue
    raise ArgumentError, "key_event must be set"
  end
  
  # for testing atributes=
  def log_key_event=(msg)
    @log_key_event = "msg:#{msg} id:#{key_event_id} key:#{key_event_key}"
  end
  
  def log_key_event
    @log_key_event
  end
end