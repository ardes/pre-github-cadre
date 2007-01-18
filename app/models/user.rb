require 'salted_hash'
require 'active_record/singleton'

class User < ActiveRecord::Base
  attr_protected :password_hash, :password_salt, :password_algorithm
  attr_reader :password
  
  validates_presence_of :email, :password_hash, :password_salt, :password_algorithm
  
  validates_uniqueness_of :email
  validates_format_of :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
  validates_confirmation_of :email
  
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 5, :allow_nil => true
  
  validates_inclusion_of :password_algorithm, :in => SaltedHash.algorithms, :message => "is not supported (#{SaltedHash.algorithms.to_sentence :connector => 'or'})"
  
  # Authenticates the given password against the one in the database.  Returns 
  # a boolean indicating whether the password was authenticated.
  #
  # If the class password_algorithm differs from the one used in this record
  # then a new password_hash (and a new salt) is created.  This allows easy upgrading of
  # password security (it is done when a User supplies their password - the only way to do it).
  #
  # We wrap this in a read lock transaction to ensure that the update corresponds to the password given.
  def authenticate_password(password)
    transaction do
      self.lock!
      hash = SaltedHash::compute(password_algorithm, password_salt, password)
      return false if hash != password_hash
      if password_algorithm != self.class.password_algorithm
        self.password = password
        save!
      end
    end
    true
  end
  
  # sets the password_hash using the given password.  The password_algorithm used is taken
  # from self.class.password_algorithm
  def password=(password)
    self.password_algorithm = self.class.password_algorithm
    self.password_salt = SaltedHash::salt
    self.password_hash = SaltedHash::compute(password_algorithm, password_salt, password)
    @password = password
  end
  
  # singleton container for the class-wide password algorithm
  class Properties < ActiveRecord::Base
    include ActiveRecord::Singleton
  end
  
  # used if a password_algorithm has not been explicitly set
  DEFAULT_PASSWORD_ALGORITHM = 'sha1'
  
  # the class-wide password_algorithm
  def self.password_algorithm
    Properties.instance.password_algorithm || DEFAULT_PASSWORD_ALGORITHM
  end
    
  # Sets the password_algorithm to be used in all future set_password calls.
  # If you want to change the algorithm for existing users, simply set this
  # attribute - as users authenticate the database will be updated with the
  # new algorithm and hash.
  def self.password_algorithm=(algorithm)
    SaltedHash::assert_supported_algorithm(algorithm)
    Properties.instance.update_attributes :password_algorithm => algorithm
  end
  
  def self.random_password
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    (1..16).inject('') {|p, _| p << chars[rand(chars.length)]}
  end
end
