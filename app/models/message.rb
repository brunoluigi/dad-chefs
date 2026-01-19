class Message < ApplicationRecord
  VISIBLE_ROLES = [ "assistant", "user" ]

  acts_as_message tool_calls_foreign_key: :message_id

  scope :visible, -> { where(role: VISIBLE_ROLES).where.not(content: nil) }

  # Only broadcast visible messages (exclude system messages)
  after_create_commit :broadcast_if_visible

  def broadcast_append_chunk(content)
    broadcast_append_to dom_id(chat),
      target: "#{dom_id(self)}_content",
      partial: "messages/content",
      locals: { content: content }
  end

  private

  def broadcast_if_visible
    # Only broadcast if this is not a system message
    return unless role.in?(VISIBLE_ROLES)

    broadcast_append_to dom_id(chat),
      target: "messages",
      partial: "messages/message",
      locals: { message: self }
  end
end
