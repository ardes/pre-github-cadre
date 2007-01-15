require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones or delete this file
context "Given a generated events_helper_spec.rb" do
  helper_name 'events'
  
  specify "the EventsHelper should be included" do
    (class << self; self; end).class_eval do
      included_modules.should_include EventsHelper
    end
  end
end
