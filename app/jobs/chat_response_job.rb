class ChatResponseJob < ApplicationJob
  def perform(chat_id, content)
    chat = Chat.find(chat_id)

    # Stream normally
    chat.ask(content) do |chunk|
      if chunk.content && !chunk.content.blank?
        message = chat.messages.last
        message.broadcast_append_chunk(chunk.content)
      end
    end

    # Post-stream processing
    assistant_message = chat.messages.where(role: "assistant").order(created_at: :desc).first
    if assistant_message
      # Check for legacy "NOT_COOKING_RELATED" responses (safety fallback)
      if assistant_message.content.to_s.strip.upcase.start_with?("NOT_COOKING_RELATED")
        Rails.logger.warn("Legacy NOT_COOKING_RELATED detected - updating to friendly message")
        assistant_message.update!(content: Chat::GUARDRAIL_ERROR_MESSAGE)
      end

      # Replace raw streamed content with properly formatted markdown
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
