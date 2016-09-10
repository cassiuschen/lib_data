require 'test_helper'

class SurviesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get survies_index_url
    assert_response :success
  end

  test "should get new" do
    get survies_new_url
    assert_response :success
  end

  test "should get create" do
    get survies_create_url
    assert_response :success
  end

  test "should get show" do
    get survies_show_url
    assert_response :success
  end

end
