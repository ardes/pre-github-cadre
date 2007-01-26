module KeyEvent
  # extend Event with this module to provide ability for an Event to be dependent on a key event
  module Has
    # Usage
    #  has_key_event :event [, :class => EventClass]
    #
    # This sets up accessors for :event, :event_id and :event_key.  If either the
    # :event_id or :event_key are set, the :event is set to nil.  The :event is then
    # found from these attributes when it is loaded (although :event can be set explicitly, not via mass update)
    #
    # A validation is added to ensure that the appropriate :event is set and exists in the database
    #
    # attributes= is patched so that the :event_id and :event_key are set before any others, to ensure
    # that other attirbutes that might depend on the :event are not set before the :event can be loaded
    def has_key_event(event, options = {})
      event_class = (options[:class] or event.to_s.classify.constantize)
      
      class_eval do
        attr_protected event
        attr_writer event
        attr_reader "#{event}_id", "#{event}_key"
      
        validate_on_create do |record|
          record.errors.add(event, "is not valid") unless record.send(event) && record.send(event).saved?(event_class)
        end
      end
      
      class_eval <<-end_eval, __FILE__, __LINE__
        def #{event}
          @#{event} or @#{event} = #{event_class.name}.find_by_id_and_key(#{event}_id,#{event}_key) rescue nil
        end
    
        def #{event}_id=(id)
          @#{event} = nil
          @#{event}_id = id
        end
      
        def #{event}_key=(key)
          @#{event} = nil
          @#{event}_key = key
        end
    
        def attributes_with_key=(new_attrs)
          key_attrs, attrs = {}, new_attrs.dup
          new_attrs.each {|k,v| key_attrs[k] = attrs.delete(k) if [:#{event}_id, :#{event}_key].include?(k.to_sym)}
          key_attrs.each {|k,v| send(k.to_s + '=',v)}
          self.attributes_without_key = attrs
        end
        alias_method_chain :attributes=, :key
      end_eval
    end
  end
end