class HomeController < ApplicationController
  def index
    return unless user_signed_in?

    # Always show the new chat form (no active chat)
    @chat = nil
    @message = nil
  end
end
