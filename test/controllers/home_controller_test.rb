require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get buslog" do
    get home_buslog_url
    assert_response :success
  end

  test "should get broadcast" do
    get home_broadcast_url
    assert_response :success
  end

end
