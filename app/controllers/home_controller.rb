class HomeController < ApplicationController
  def index
    return unless user_signed_in?

    if params[:new_chat]
      @chat = nil
      @message = nil
    elsif params[:chat_id]
      @chat = current_user.chats.find_by(id: params[:chat_id])
      @message = @chat&.messages&.build
    else
      # Show the new chat form by default (no active chat)
      @chat = nil
      @message = nil
    end
  end
end
