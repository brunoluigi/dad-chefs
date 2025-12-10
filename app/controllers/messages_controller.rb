class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def create
    return unless content.present?

    ChatResponseJob.perform_later(@chat.id, content)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path(chat_id: @chat.id) }
    end
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  def content
    params[:message][:content]
  end
end
