require 'test_helper'

class EmoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get emo_index_url
    assert_response :success
  end

  test "should get destroy" do
    get emo_destroy_url
    assert_response :success
  end

  test "should get create" do
    get emo_create_url
    assert_response :success
  end

end
