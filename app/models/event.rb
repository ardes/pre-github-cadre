require 'active_record/singleton'

#  Signup
#  UserEvent
#    NonActivatedUserEvent
#      SignupCancellation
#      Activation
#    ActivatedUserEvent
#      Recognition
#      Login
#      PasswordResetRequest
#      PasswordReset
class Event < ActiveRecord::Base
  belongs_to :user
  
  attr_protected :user_id, :created_at

  validates_format_of :ip_address, :allow_nil => true, :with => /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
  
  # All events are readonly after they have been created
  after_create {|event| event.readonly!}
  def after_find; readonly!; end
  
  # singleton container for class-wide properties
  class Properties < ActiveRecord::Base
    include ActiveRecord::Singleton
  end
  
  
  # Include this module to have your Event generate a key when it is created.
  # After create you should store the id, and either the key, or key_hash, depending on
  # whether you want to simply match the key_hash, or compute the key_hash from the key.
  # The latter is more secure, but may not be appropriate for simple sessions.
  # 
  # You can then find the event with either
  #  * find_by_id_and_key - which computes the hash from the given key and matches that, or
  #  * find_by_id_and_key_hash - which simply selects on id and key_hash
  module GenerateKey
    def self.included(base)
      require 'salted_hash'
      base.class_eval do
        extend ClassMethods
        attr_protected :key_hash, :key_algorithm
        attr_reader :key
        before_create {|event| event.generate_key}
      end
    end

    def generate_key
      self.key_algorithm = self.class.key_algorithm
      @key = SaltedHash.compute(self.key_algorithm, "--#{self.id}--#{Time.now}--", SaltedHash.salt(4))
      self.key_hash = SaltedHash.compute(self.key_algorithm, @key)
    end

    def match_key_hash?(key)
      self.key_hash == SaltedHash.compute(key_algorithm, key)
    end
    
    module ClassMethods
      def find_by_id_and_key(id, key)
        ((signup = find(id)) && signup.match_key_hash?(key)) ? signup : nil
      end
      
      def properties_class
        @properties_class ||= "::#{self.name}::Properties".constantize
      end
      
      # the class-wide key_algorithm
      def key_algorithm
        properties_class.instance.key_algorithm or self.key_algorithm = 'sha1'
      end

      # Sets the key_algorithm to be used in all future key hashes
      def key_algorithm=(algorithm)
        SaltedHash::assert_supported_algorithm(algorithm)
        properties_class.instance.update_attributes :key_algorithm => algorithm
      end
    end
  end
end