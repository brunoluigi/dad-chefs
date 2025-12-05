require "test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "should get index" do
    get recipes_url
    assert_response :success
  end

  test "should get show" do
    get recipe_url(recipes(:one))
    assert_response :success
  end

  test "should get search" do
    get search_recipes_url
    assert_response :success
  end
end
