require "test_helper"

class Users::MagicLinksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_session_path
    assert_response :success
    assert_select "h2", "Sign in or Sign up"
  end

  test "should create new user and send magic link for new email" do
    email = "newuser@example.com"

    assert_difference("User.count", 1) do
      post user_session_path, params: { user: { email: email } }
    end

    user = User.find_by(email: email)
    assert_not_nil user
    assert_redirected_to root_path
  end

  test "should send magic link for existing user" do
    existing_user = users(:one)

    assert_no_difference("User.count") do
      post user_session_path, params: { user: { email: existing_user.email } }
    end

    assert_redirected_to root_path
  end

  test "should handle blank email" do
    post user_session_path, params: { user: { email: "" } }

    assert_response :success
    assert_select "h2", "Sign in or Sign up"
  end

  test "should handle invalid email format" do
    assert_no_difference("User.count") do
      post user_session_path, params: { user: { email: "invalid-email" } }
    end
  end

  test "should normalize email to lowercase" do
    email = "NewUser@Example.COM"

    post user_session_path, params: { user: { email: email } }

    user = User.find_by(email: email.downcase)
    assert_not_nil user
    assert_equal email.downcase, user.email
  end

  test "should strip whitespace from email" do
    email = "  user@example.com  "

    post user_session_path, params: { user: { email: email } }

    user = User.find_by(email: email.strip.downcase)
    assert_not_nil user
    assert_equal email.strip.downcase, user.email
  end

  test "old sign_up path should redirect to sign_in" do
    get users_sign_up_path
    assert_redirected_to new_user_session_path
  end
end
