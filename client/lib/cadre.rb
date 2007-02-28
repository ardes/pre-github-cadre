require RAILS_ROOT + '/vendor/rails/activeresource/lib/active_resource'

module Cadre
  class Base < ActiveResource::Base
    class << self
      # we demodulize Cadre resources, so Cadre::User.find(:all) => /users.xml
      attr_accessor_with_default(:element_name) { to_s.demodulize.underscore }
    end
    
    self.site     = 'http://portableDD.local:3000'
    site.user     = 'client'
    site.password = 'password'
  end

  class User < Base
    def events
      User::Event.find :all, :user_id => self.id
    end
  
    class Event < Base
      self.site += '/users/:user_id'
    end
  end
  
  class Event < Base
    attr_reader :key
    
    # Events sometimes set a digest key in the headers which represents a
    # one time key that is not stored in the database, so we need create to
    # extract that where it is set.
    def create(*args)
      returning super(*args) do |response|
        @key = response['Key'] if response['Key']
      end
    end
  end
  
  class Activation < Event; end
  
  class ActivationSignup < Event; end
  
  class Signup < Event; end
  
  class SignupCancellation < Event; end
  
  class Recognition < Event; end
  
  class Login < Event; end
end  