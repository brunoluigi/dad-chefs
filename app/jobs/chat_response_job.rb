class ChatResponseJob < ApplicationJob
  def perform(chat_id, content)
    chat = Chat.find(chat_id)

    # Don't stream during the ask - let it complete first
    chat.ask(content)

    # Broadcast the complete formatted message
    assistant_message = chat.messages.where(role: "assistant").order(created_at: :desc).first
    if assistant_message
      # Check for legacy "NOT_COOKING_RELATED" responses (safety fallback)
      if assistant_message.content.to_s.strip.upcase.start_with?("NOT_COOKING_RELATED")
        Rails.logger.warn("Legacy NOT_COOKING_RELATED detected - updating to friendly message")
        assistant_message.update!(content: Chat::GUARDRAIL_ERROR_MESSAGE)
      end

      # Broadcast with markdown formatting
      assistant_message.broadcast_replace_to "chat_#{assistant_message.chat_id}",
        target: "message_#{assistant_message.id}",
        partial: "messages/message",
        locals: { message: assistant_message, show_error: false }
    end
  rescue => e
    Rails.logger.error("ChatResponseJob failed: #{e.message}")
    raise
  end
end
