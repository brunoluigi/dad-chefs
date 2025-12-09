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
      # Check for guardrail violation
      if assistant_message.content.to_s.strip.upcase.start_with?("NOT_COOKING_RELATED")
        handle_not_cooking_related(assistant_message)
      else
        # Replace raw streamed content with properly formatted markdown
        broadcast_formatted_message(assistant_message)
      end
    end
  rescue => e
    Rails.logger.error("ChatResponseJob failed: #{e.message}")
    raise
  end

  private

  def handle_not_cooking_related(message)
    Rails.logger.info("Guardrail triggered for message #{message.id}")

    message.update!(content: Chat::GUARDRAIL_ERROR_MESSAGE)

    message.broadcast_replace_to "chat_#{message.chat_id}",
      target: "message_#{message.id}",
      partial: "messages/message",
      locals: { message: message, show_error: true }
  end

  def broadcast_formatted_message(message)
    # Broadcast the complete message with markdown formatting
    message.broadcast_replace_to "chat_#{message.chat_id}",
      target: "message_#{message.id}",
      partial: "messages/message",
      locals: { message: message, show_error: false }
  end
end