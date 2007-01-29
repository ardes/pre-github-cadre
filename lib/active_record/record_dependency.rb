module ActiveRecord
  module RecordDependency
    def self.included(base)
      base.class_eval do
        alias_method_chain :save, :record_dependency
      end
    end
    
    # Allow after_create and after_save to abort the save with an invalid record, grab those errors.
    # This allows triggered creation of records, the failure of any will abort the entire transaction
    def save_with_record_dependency(*args)
      save_without_record_dependency(*args)
    rescue ActiveRecord::RecordInvalid => invalid
      errors.add_to_base("#{invalid.record.class.name.humanize} is not valid")
      false
    end
  end
end