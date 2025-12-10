class Message < ApplicationRecord
  acts_as_message tool_calls_foreign_key: :message_id

  scope :visible, -> { where.not(role: "system") }

  # Only broadcast visible messages (exclude system messages)
  after_create_commit :broadcast_if_visible

  def broadcast_append_chunk(content)
    broadcast_append_to "chat_#{chat_id}",
      target: "message_#{id}_content",
      partial: "messages/content",
      locals: { content: content }
  end

  private

  def broadcast_if_visible
    # Only broadcast if this is not a system message
    return if role == "system"

    broadcast_append_to "chat_#{chat_id}",
      target: "messages",
      partial: "messages/message",
      locals: { message: self }
  end
end
