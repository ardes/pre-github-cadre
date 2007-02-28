require File.dirname(__FILE__) + '/../test_helper'
require 'foos_controller'

# Re-raise errors caught by the controller.
class FoosController; def rescue_action(e) raise e end; end

class FoosControllerTest < Test::Unit::TestCase
  fixtures :foos

  def setup
    @controller = FoosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:foos)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_foo
    old_count = Foo.count
    post :create, :foo => { }
    assert_equal old_count+1, Foo.count
    
    assert_redirected_to foo_path(assigns(:foo))
  end

  def test_should_show_foo
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_foo
    put :update, :id => 1, :foo => { }
    assert_redirected_to foo_path(assigns(:foo))
  end
  
  def test_should_destroy_foo
    old_count = Foo.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Foo.count
    
    assert_redirected_to foos_path
  end
end
