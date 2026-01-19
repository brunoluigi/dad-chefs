class ChatResponseJob < ApplicationJob
  def perform(chat_id, content)
    chat = Chat.find(chat_id)

    chat
      .with_tools(ListRecipesTool.new(chat.user))
      .with_tools(ShowRecipeTool.new(chat.user))
      .with_tools(SaveRecipeTool.new(chat.user))
      .with_tools(DeleteRecipeTool.new(chat.user))
      .on_tool_call do |tool_call|
        # Called when the AI decides to use a tool
        puts "Calling tool: #{tool_call.name}"
        puts "User: #{chat.user}"
        puts "Arguments: #{tool_call.arguments}"
      end
      .on_tool_result do |result|
        # Called after the tool returns its result
        puts "Tool returned: #{result}"
      end

    # Stream normally
    chat.ask(content) do |chunk|
      if chunk.content && !chunk.content.blank?
        message = chat.messages.visible.last
        message.broadcast_append_chunk(chunk.content)
      end
    end

    # Post-stream processing: replace raw streamed content with properly formatted markdown
    assistant_message = chat.messages.visible.where(role: "assistant").last
    if assistant_message
      assistant_message.broadcast_replace_to dom_id(chat),
        target: dom_id(assistant_message),
        partial: "messages/message",
        locals: { message: assistant_message, show_error: false }
    end
  rescue => e
    Rails.logger.error("ChatResponseJob failed: #{e.message}")
    raise
  end
end
