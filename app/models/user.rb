require 'rfc822'
require 'salted_hash'
require 'active_record/singleton'

class User < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  has_one :signup
  belongs_to :activation
  
  attr_protected :password_hash, :password_salt, :password_algorithm
  attr_accessor :password
  
  validates_presence_of :email
  validates_format_of :email, :allow_nil => true, :with => RFC822::EmailAddress
  validates_uniqueness_of :email
  validates_confirmation_of :email
  
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password, :if => :password_supplied?
  validates_length_of :password, :minimum => 5, :allow_nil => true, :if => :password_supplied?
  
  validates_format_of :display_name, :allow_nil => true, :with => /^[a-z]{2}(?:[.'\-\w ]+)?$/i
  
  before_save {|user| user.hash_password(user.password) if user.password_supplied?}
  
  # list of methods that would typically be delegated to this class, which can then be used as follows (in the other class):
  #  delegate *User.delegate_methods.push(:to => :user)
  def self.delegate_methods
    @delegate_methods ||= [:email, :email_confirmation, :password, :password_confirmation, :display_name].collect{|m| [m, "#{m}=".to_sym]}.flatten
  end
  
  # singleton container for the class-wide password algorithm
  class Properties < ActiveRecord::Base
    include ActiveRecord::Singleton
  end
  
  # the class-wide password_algorithm
  def self.password_algorithm
    Properties.instance.password_algorithm or self.password_algorithm = 'sha1'
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
  
  # use the current email as confirmation if the confirmation is nil or false (note: a blank confirmation will be used)
  def email_confirmation
    @email_confirmation or email
  end
  
  # computes name from display_name, then email
  def name
    display_name or (email and email.sub('.',' ').sub(/@.*$/,'').titleize)
  end
  
  # computes email_address from name and email
  def email_address
    "#{name} <#{email}>" if email
  end
  
  def activated?
    !activation_id.nil?
  end
  
  def activate!(activation)
    raise ArgumentError, "activation must be a saved Activation" unless activation.saved?(Activation)
    raise ArgumentError, "activation's user must be this user" unless self.id == activation.user_id
    update_attribute :activation_id, activation.id
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
    password_hash == SaltedHash::compute(password_algorithm, password, password_salt)
  end
  
  # sets the password_hash using the given password.  The password_algorithm used is taken
  # from self.class.password_algorithm
  def hash_password(password)
    self.password_algorithm = self.class.password_algorithm
    self.password_salt = SaltedHash::salt
    self.password_hash = SaltedHash::compute(password_algorithm, password, password_salt)
  end
  
  # return a random password
  def self.random_password
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    (1..16).inject('') {|p, _| p << chars[rand(chars.length)]}
  end
  
  def self.find_activated(*args)
    with_scope(:find => {:conditions => 'activate_id IS NOT NULL'}) { find(*args) }
  end
end