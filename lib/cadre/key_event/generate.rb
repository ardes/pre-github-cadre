module Cadre
  module KeyEvent
    # Include this module to have your Event generate a key when it is created.
    # After create you should store the id, and either the key, or key_hash, depending on
    # whether you want to simply match the key_hash, or compute the key_hash from the key.
    # The latter is more secure, but may not be appropriate for simple sessions.
    # 
    # You can then find the event with either
    #  * find_by_id_and_key - which computes the hash from the given key and matches that, or
    #  * find_by_id_and_key_hash - which simply selects on id and key_hash
    #
    # The reason we use an id and a key to find the record is that the key hash model is upgradeable, and has the key_algorithm
    # stored in the model.  This means that we must first find the target record, and then match the hash.
    module Generate
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
end