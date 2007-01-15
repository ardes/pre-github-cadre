require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the UsersController should map" do
  controller_name :users

  specify "{ :controller => 'users', :action => 'index' } to /users" do
    route_for(:controller => "users", :action => "index").should_eql "/users"
  end
  
  specify "{ :controller => 'users', :action => 'new' } to /users/new" do
    route_for(:controller => "users", :action => "new").should_eql "/users/new"
  end
  
  specify "{ :controller => 'users', :action => 'show', :id => 1 } to /users/1" do
    route_for(:controller => "users", :action => "show", :id => 1).should_eql "/users/1"
  end
  
  specify "{ :controller => 'users', :action => 'edit', :id => 1 } to /users/1;edit" do
    route_for(:controller => "users", :action => "edit", :id => 1).should_eql "/users/1;edit"
  end
  
  specify "{ :controller => 'users', :action => 'update', :id => 1} to /users/1" do
    route_for(:controller => "users", :action => "update", :id => 1).should_eql "/users/1"
  end
  
  specify "{ :controller => 'users', :action => 'destroy', :id => 1} to /users/1" do
    route_for(:controller => "users", :action => "destroy", :id => 1).should_eql "/users/1"
  end
end

context "Requesting /users using GET" do
  controller_name :users

  setup do
    @mock_users = mock('users')
    User.stub!(:find).and_return(@mock_users)
  end
  
  def do_get
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should_be_success
  end

  specify "should render index.rhtml" do
    controller.should_render :index
    do_get
  end
  
  specify "should find all users" do
    User.should_receive(:find).with(:all).and_return(@mock_users)
    do_get
  end
  
  specify "should assign the found users for the view" do
    do_get
    assigns[:users].should_be @mock_users
    
  end
end

context "Requesting /users.xml using GET" do
  controller_name :users

  setup do
    @mock_users = mock('users')
    @mock_users.stub!(:to_xml).and_return("XML")
    User.stub!(:find).and_return(@mock_users)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should_be_success
  end

  specify "should find all users" do
    User.should_receive(:find).with(:all).and_return(@mock_users)
    do_get
  end
  
  specify "should render the found users as xml" do
    @mock_users.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should_eql "XML"
  end
end

context "Requesting /users/1 using GET" do
  controller_name :users

  setup do
    @mock_user = mock('User')
    User.stub!(:find).and_return(@mock_user)
  end
  
  def do_get
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should_be_success
  end
  
  specify "should render show.rhtml" do
    controller.should_render :show
    do_get
  end
  
  specify "should find the user requested" do
    User.should_receive(:find).with("1").and_return(@mock_user)
    do_get
  end
  
  specify "should assign the found user for the view" do
    do_get
    assigns[:user].should_be @mock_user
  end
end

context "Requesting /users/1.xml using GET" do
  controller_name :users

  setup do
    @mock_user = mock('User')
    @mock_user.stub!(:to_xml).and_return("XML")
    User.stub!(:find).and_return(@mock_user)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should_be_success
  end
  
  specify "should find the user requested" do
    User.should_receive(:find).with("1").and_return(@mock_user)
    do_get
  end
  
  specify "should render the found user as xml" do
    @mock_user.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should_eql "XML"
  end
end

context "Requesting /users/new using GET" do
  controller_name :users

  setup do
    @mock_user = mock('User')
    User.stub!(:new).and_return(@mock_user)
  end
  
  def do_get
    get :new
  end

  specify "should be successful" do
    do_get
    response.should_be_success
  end
  
  specify "should render new.rhtml" do
    controller.should_render :new
    do_get
  end
  
  specify "should create an new user" do
    User.should_receive(:new).and_return(@mock_user)
    do_get
  end
  
  specify "should not save the new user" do
    @mock_user.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new user for the view" do
    do_get
    assigns[:user].should_be @mock_user
  end
end

context "Requesting /users/1;edit using GET" do
  controller_name :users

  setup do
    @mock_user = mock('User')
    User.stub!(:find).and_return(@mock_user)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should_be_success
  end
  
  specify "should render edit.rhtml" do
    do_get
    controller.should_render :edit
  end
  
  specify "should find the user requested" do
    User.should_receive(:find).and_return(@mock_user)
    do_get
  end
  
  specify "should assign the found User for the view" do
    do_get
    assigns(:user).should_equal @mock_user
  end
end

context "Requesting /users using POST" do
  controller_name :users

  setup do
    @mock_user = mock('User')
    @mock_user.stub!(:save).and_return(true)
    @mock_user.stub!(:to_param).and_return(1)
    User.stub!(:new).and_return(@mock_user)
  end
  
  def do_post
    post :create, :user => {:name => 'User'}
  end
  
  specify "should create a new user" do
    User.should_receive(:new).with({'name' => 'User'}).and_return(@mock_user)
    do_post
  end

  specify "should redirect to the new user" do
    do_post
    response.should_be_redirect
    response.redirect_url.should_eql "http://test.host/users/1"
  end
end

context "Requesting /users/1 using PUT" do
  controller_name :users

  setup do
    @mock_user = mock('User', :null_object => true)
    @mock_user.stub!(:to_param).and_return(1)
    User.stub!(:find).and_return(@mock_user)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the user requested" do
    User.should_receive(:find).with("1").and_return(@mock_user)
    do_update
  end

  specify "should update the found user" do
    @mock_user.should_receive(:update_attributes)
    do_update
    assigns(:user).should_be @mock_user
  end

  specify "should assign the found user for the view" do
    do_update
    assigns(:user).should_be @mock_user
  end

  specify "should redirect to the user" do
    do_update
    response.should_be_redirect
    response.redirect_url.should_eql "http://test.host/users/1"
  end
end

context "Requesting /users/1 using DELETE" do
  controller_name :users

  setup do
    @mock_user = mock('User', :null_object => true)
    User.stub!(:find).and_return(@mock_user)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the user requested" do
    User.should_receive(:find).with("1").and_return(@mock_user)
    do_delete
  end
  
  specify "should call destroy on the found user" do
    @mock_user.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the users list" do
    do_delete
    response.should_be_redirect
    response.redirect_url.should_eql "http://test.host/users"
  end
end