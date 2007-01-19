require 'salted_hash'
require 'active_record/singleton'

# 
#
class User < ActiveRecord::Base
  attr_protected :password_hash, :password_salt, :password_algorithm
  attr_accessor :password
  
  validates_presence_of :email
  validates_format_of :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
  validates_uniqueness_of :email
  validates_confirmation_of :email
  
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password, :if => :password_supplied?
  validates_length_of :password, :minimum => 5, :allow_nil => true, :if => :password_supplied?
  
  validates_each 
  
  before_save {|user| user.hash_password(user.password) if user.password_supplied?}
  
  # singleton container for the class-wide password algorithm
  class Properties < ActiveRecord::Base
    include ActiveRecord::Singleton
  end
  
  # used if the class-wide password_algorithm has been set
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
  
  def password_supplied?
    !password.blank?
  end
  
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
      return false unless match_password_hash?(password)
      if password_algorithm != self.class.password_algorithm
        hash_password(password)
        save!
      end
    end
    true
  end
  
  # computes a hash with the given password and compares it to the password_hash attribute of this User
  def match_password_hash?(password)
    password_hash == SaltedHash::compute(password_algorithm, password_salt, password)
  end
  
  # sets the password_hash using the given password.  The password_algorithm used is taken
  # from self.class.password_algorithm
  def hash_password(password)
    self.password_algorithm = self.class.password_algorithm
    self.password_salt = SaltedHash::salt
    self.password_hash = SaltedHash::compute(password_algorithm, password_salt, password)
  end
  
  # return a random password
  def self.random_password
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    (1..16).inject('') {|p, _| p << chars[rand(chars.length)]}
  end
end
