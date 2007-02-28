# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include BrowserFilters
  session :off, :if => proc { |request| [:rss, :atom, :xml].include? request.format.to_sym }
  before_filter :authenticate
  
protected
  def authenticate
    authenticate_or_request_with_http_basic("Cadre") do |username, password|
      (username == CADRE_CLIENT_USERNAME && password == CADRE_CLIENT_PASSWORD) || (username == CADRE_ADMIN_USERNAME && password == CADRE_ADMIN_PASSWORD)
    end
  end
  
  def authorize(type)
    authenticate_or_request_with_http_basic("Cadre") do |username, password|
      (type == :admin && username == CADRE_ADMIN_USERNAME) || (type == :client && username == CADRE_CLIENT_USERNAME)
    end
  end
  
  def require_admin
    authorize :admin
  end
  
  def require_client
    authorize :client
  end
end