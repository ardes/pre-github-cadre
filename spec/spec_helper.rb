ENV["RAILS_ENV"] = "test"
# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails'

# Even if you're using RSpec, RSpec on Rails is reusing some of the
# Rails-specific extensions for fixtures and stubbed requests, response
# and other things (via RSpec's inherit mechanism). These extensions are 
# tightly coupled to Test::Unit in Rails, which is why you're seeing it here.
module Spec
  module Rails
    class EvalContext < Test::Unit::TestCase
      cattr_accessor :fixture_path, :use_transactional_fixtures, :use_instantiated_fixtures
      self.use_transactional_fixtures = true
      self.use_instantiated_fixtures  = false
      self.fixture_path = RAILS_ROOT + '/spec/fixtures'

      # You can set up your global fixtures here, or you
      # can do it in individual contexts
      #fixtures :table_a, :table_b
    end
  end
end

module MailerSpecHelper#:nodoc
  def self.included(base)
    base.class_eval do
      include ActionMailer::Quoting
      include ActionController::UrlWriter
    end
  end
  
  def setup_mailer
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    @queue = ActionMailer::Base.deliveries = []
  end
end