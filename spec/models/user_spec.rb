require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated user_spec.rb with fixtures loaded" do
  fixtures :users

  specify "fixtures should load two Users" do
    User.should_have(2).records
  end

  specify "you should add more specs" do
    violated "not enough specs"
  end
end
