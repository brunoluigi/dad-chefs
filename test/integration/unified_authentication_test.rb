require "test_helper"

class UnifiedAuthenticationTest < ActionDispatch::IntegrationTest
  test "new user can sign up with email and receive magic link" do
    # Visit the sign in page
    get new_user_session_path
    assert_response :success

    # Submit email for new user
    new_email = "newuser@example.com"
    assert_difference("User.count", 1) do
      post user_session_path, params: { user: { email: new_email } }
    end

    # User should be created
    new_user = User.find_by(email: new_email)
    assert_not_nil new_user

    # Should redirect to root with success message
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "existing user can sign in with email and receive magic link" do
    existing_user = users(:one)

    # Visit the sign in page
    get new_user_session_path
    assert_response :success

    # Submit email for existing user
    assert_no_difference("User.count") do
      post user_session_path, params: { user: { email: existing_user.email } }
    end

    # Should redirect to root
    assert_redirected_to root_path
  end

  test "unified flow handles both new and existing users seamlessly" do
    # Test with new user
    new_email = "brandnew@example.com"
    post user_session_path, params: { user: { email: new_email } }
    assert User.exists?(email: new_email), "New user should be created"

    # Test with the now-existing user
    post user_session_path, params: { user: { email: new_email } }
    assert_equal 1, User.where(email: new_email).count, "Should not create duplicate user"
  end

  test "sign up path redirects to unified sign in path" do
    get users_sign_up_path
    assert_redirected_to new_user_session_path

    follow_redirect!
    assert_response :success
    assert_select "h2", "Sign in or Sign up"
  end

  test "form shows appropriate messaging for unified flow" do
    get new_user_session_path

    assert_select "h2", "Sign in or Sign up"
    assert_select "p", text: /create an account for you if you're new/i
    assert_select "input[type=submit][value='Continue with email']"
  end
end
