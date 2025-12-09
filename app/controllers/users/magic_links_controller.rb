# frozen_string_literal: true

class Users::MagicLinksController < Devise::Passwordless::SessionsController
  def new
    # Show the unified sign in/sign up form
    self.resource = resource_class.new
    render :new
  end

  def create
    # Find or create user, then send magic link
    email = params.dig(:user, :email)&.downcase&.strip

    if email.blank?
      set_flash_message!(:alert, :invalid_email)
      self.resource = resource_class.new
      render :new and return
    end

    # Find or create the user
    user = User.find_or_initialize_by(email: email)

    if user.new_record?
      # New user - create them
      unless user.save
        set_flash_message!(:alert, :email_invalid)
        self.resource = user
        render :new and return
      end
    end

    # Send magic link (Devise passwordless handles this)
    self.resource = user
    super
  end
end
