# Chat Feature Specification - Sous Chef Recipe Assistant

## Overview
The Sous Chef chat feature is an AI-powered chatbot designed to help parents find healthy recipes to cook for their children. The chatbot has built-in guardrails to ensure it only responds to cooking-related queries.

## Current Implementation Status

### ✅ What's Already Built

#### Models & Data Layer
- **Chat Model** ([app/models/chat.rb](../app/models/chat.rb))
  - Uses `acts_as_chat` from ruby_llm gem
  - Belongs to User
  - Has system instructions defining Sous Chef personality
  - Includes `NOT_COOKING_RELATED` guardrail in system prompt

- **Message Model** ([app/models/message.rb](../app/models/message.rb))
  - Uses `acts_as_message` from ruby_llm gem
  - Broadcasts to turbo streams for real-time updates
  - Has `broadcast_append_chunk` method for streaming responses

#### Controllers
- **ChatsController** ([app/controllers/chats_controller.rb](../app/controllers/chats_controller.rb))
  - ✅ `index` - List all user chats
  - ✅ `new` - New chat form
  - ✅ `create` - Create chat and start job
  - ✅ `show` - Display chat conversation
  - ✅ Authentication via `before_action :authenticate_user!`

- **MessagesController** ([app/controllers/messages_controller.rb](../app/controllers/messages_controller.rb))
  - ✅ `create` - Add user message and trigger AI response
  - ✅ Turbo stream support for real-time updates

#### Background Jobs
- **ChatResponseJob** ([app/jobs/chat_response_job.rb](../app/jobs/chat_response_job.rb))
  - ✅ Processes chat messages asynchronously
  - ✅ Streams chunks to UI via turbo broadcasts

#### Views & UI
- ✅ Chat index page ([app/views/chats/index.html.erb](../app/views/chats/index.html.erb))
- ✅ Chat show page with message history ([app/views/chats/show.html.erb](../app/views/chats/show.html.erb))
- ✅ Message partial with user/assistant styling ([app/views/chats/_message.html.erb](../app/views/chats/_message.html.erb))
- ✅ Real-time streaming via Turbo Streams
- ✅ Tailwind CSS styling with chef theme (👨‍🍳)

#### Routes
- ✅ Nested routes: `resources :chats` with nested `resources :messages`

## 🔧 What Needs to Be Implemented

### High Priority

#### 1. NOT_COOKING_RELATED Response Handling
**Status:** ✅ Implemented and improved

**Implementation:**
- ✅ ChatResponseJob detects "NOT_COOKING_RELATED" response after streaming
- ✅ Friendly error message defined in Chat::GUARDRAIL_ERROR_MESSAGE constant
- ✅ Yellow warning box displays error message (matches existing error pattern)
- ✅ Error message replaces sentinel text in database
- ✅ Case-insensitive matching with edge case handling
- ✅ Message#guardrail_error? helper method added
- ✅ Enhanced system prompt with clear examples of cooking vs non-cooking queries
- ✅ Explicit support for international cuisine and recipe names in any language
- ✅ Detailed categorization to prevent false positives

**Files Modified:**
- [app/models/chat.rb](../app/models/chat.rb) - Added GUARDRAIL_ERROR_MESSAGE constant and improved system instructions
- [app/jobs/chat_response_job.rb](../app/jobs/chat_response_job.rb) - Post-stream detection logic
- [app/views/chats/_message.html.erb](../app/views/chats/_message.html.erb) - Error display UI
- [app/models/message.rb](../app/models/message.rb) - Helper method

**Known Issues Fixed:**
- ✅ Fixed false positive for international recipe names (e.g., "cocido madrileño")
- ✅ Added comprehensive examples to prevent misclassification

**Important Note:**
System instructions are set when a chat is created. To see improved guardrails, start a new chat.

**Still Needed:**
- [ ] Write tests for guardrail functionality

#### 2. Recipe Suggestion Integration
**Status:** ❌ Not implemented

**What's Needed:**
- [ ] Add ability to save suggested recipes from chat to user's cookbook
- [ ] Parse recipe suggestions from chat messages (detect recipe blocks/titles)
- [ ] Add "Save to Cookbook" buttons next to recipe suggestions
- [ ] Implement action to create Recipe and Cookbook records from chat
- [ ] Add visual indicator when a recipe is saved
- [ ] Handle duplicate recipe saves gracefully

#### 3. Enhanced Conversation Flow
**Status:** ⚠️ Basic flow implemented, needs enhancement

**What's Needed:**
- [ ] Add suggested prompts/quick actions for first-time users
- [ ] Implement conversation starters (e.g., "Quick weeknight dinner", "Picky eater meals")
- [ ] Add dietary preference capture (allergies, vegetarian, etc.)
- [ ] Store user preferences in Chat or User model
- [ ] Include preferences in system instructions for better suggestions

### Medium Priority

#### 4. Message Formatting & Display
**Status:** ✅ Markdown rendering implemented

**Implementation:**
- ✅ Markdown rendering with Redcarpet for assistant messages
- ✅ Syntax highlighting with Rouge for code blocks
- ✅ Recipe ingredients rendered as formatted lists
- ✅ Cooking steps with numbered lists
- ✅ Custom Tailwind prose styles for chat context
- ✅ Support for tables, blockquotes, headings, links
- ✅ Inline code highlighting with amber theme
- ✅ Post-stream message replacement for proper markdown rendering with Turbo Streams

**Files Modified:**
- [app/helpers/application_helper.rb](../app/helpers/application_helper.rb) - Markdown helper with Rouge integration
- [app/views/chats/_message.html.erb](../app/views/chats/_message.html.erb) - Uses markdown() helper
- [app/assets/stylesheets/rouge.css](../app/assets/stylesheets/rouge.css) - Syntax highlighting
- [app/assets/stylesheets/chat.css](../app/assets/stylesheets/chat.css) - Custom prose styles
- [app/views/layouts/application.html.erb](../app/views/layouts/application.html.erb) - Added CSS links
- [app/jobs/chat_response_job.rb](../app/jobs/chat_response_job.rb) - Post-stream markdown formatting

**Still Needed:**
- [ ] Add copy-to-clipboard functionality for recipes
- [ ] Add timestamp display for messages

#### 4.1 Keyboard Shortcuts
**Status:** ✅ Implemented

**Implementation:**
- ✅ Shift+Enter keyboard shortcut to submit chat form
- ✅ Works in all chat forms across the application
- ✅ Placeholder text updated to indicate shortcut availability
- ✅ Stimulus controller handles keyboard events
- ✅ Input field clears automatically after submission

**Files Modified:**
- [app/javascript/controllers/chat_form_controller.js](../app/javascript/controllers/chat_form_controller.js) - Stimulus controller
- [app/views/chats/show.html.erb](../app/views/chats/show.html.erb) - Message input form
- [app/views/chats/_form.html.erb](../app/views/chats/_form.html.erb) - New chat form
- [app/views/home/_chat.html.erb](../app/views/home/_chat.html.erb) - Home page chat forms (both existing and new chat)

#### 5. Chat Management Features
**Status:** ⚠️ Basic CRUD exists, needs UX improvement

**What's Needed:**
- [ ] Add chat title/name (auto-generated from first message)
- [ ] Implement delete chat functionality
- [ ] Add chat search/filter on index page
- [ ] Show preview of last message in chat list
- [ ] Add pagination for chat list
- [ ] Add "Continue where you left off" on homepage

#### 6. Model Selection
**Status:** ⚠️ Model parameter exists but not fully utilized

**What's Needed:**
- [ ] Create UI for model selection in new chat form
- [ ] Display available models (integrate with ModelsController)
- [ ] Show current model in chat view
- [ ] Allow model switching mid-conversation (if appropriate)
- [ ] Add model capabilities description

### Low Priority

#### 7. Error Handling & Edge Cases
**Status:** ❌ Minimal error handling

**What's Needed:**
- [ ] Handle LLM API failures gracefully
- [ ] Show error messages for failed responses
- [ ] Add retry functionality for failed messages
- [ ] Handle rate limiting
- [ ] Add loading states during message processing
- [ ] Timeout handling for long-running requests

#### 8. User Experience Enhancements
**Status:** ❌ Not implemented

**What's Needed:**
- [ ] Add typing indicator while AI is responding
- [ ] Auto-scroll to bottom on new messages
- [ ] Add "Stop generating" button during streaming
- [ ] Implement message reactions/feedback (thumbs up/down)
- [ ] Add "Share recipe" functionality
- [ ] Export chat/recipe to PDF or email

#### 9. Analytics & Insights
**Status:** ❌ Not implemented

**What's Needed:**
- [ ] Track popular recipe requests
- [ ] Log guardrail triggers (how often users ask non-cooking questions)
- [ ] Measure chat session duration
- [ ] Track recipe save rate from chats
- [ ] Add admin dashboard for chat analytics

### Testing Requirements

#### Unit Tests
- [ ] Chat model tests (test/models/chat_test.rb)
  - [ ] Test system instructions setup
  - [ ] Test user association

- [ ] Message model tests (test/models/message_test.rb)
  - [ ] Test broadcasting functionality
  - [ ] Test content validation

#### Controller Tests
- [ ] ChatsController tests
  - [ ] Test index action with multiple chats
  - [ ] Test create action
  - [ ] Test show action
  - [ ] Test authentication requirements

- [ ] MessagesController tests
  - [ ] Test create action
  - [ ] Test turbo stream response
  - [ ] Test authentication requirements

#### Integration Tests
- [ ] End-to-end chat flow test
  - [ ] User creates new chat
  - [ ] User sends message
  - [ ] AI responds appropriately
  - [ ] Conversation history is saved

- [ ] Guardrail integration test
  - [ ] Test non-cooking query detection
  - [ ] Test appropriate error message display
  - [ ] Test that non-cooking messages are handled correctly

- [ ] Recipe saving from chat test
  - [ ] Test recipe extraction from chat
  - [ ] Test saving to cookbook

#### Job Tests
- [ ] ChatResponseJob tests
  - [ ] Test job execution
  - [ ] Test chunk broadcasting
  - [ ] Test error handling

## Technical Considerations

### Performance
- Implement job queuing with Solid Queue (already in Gemfile)
- Consider caching frequently requested recipes
- Monitor LLM API costs and response times
- Implement rate limiting per user

### Security
- Ensure all chat actions require authentication ✅
- Sanitize user input before sending to LLM
- Validate that users can only access their own chats ✅
- Implement content moderation if needed

### Data Privacy
- Consider adding chat deletion/export features
- Clear user expectations about data storage
- Implement data retention policies

## Future Enhancements (Beyond Current Scope)

- Voice input for recipe requests
- Image upload for "What can I make with this?"
- Multi-language support
- Recipe difficulty ratings
- Cooking time estimates
- Nutritional information display
- Integration with grocery delivery services
- Meal planning calendar
- Kids' age-appropriate suggestions

## Dependencies

- ✅ ruby_llm gem (already installed)
- ✅ devise (authentication)
- ✅ turbo-rails (real-time updates)
- ✅ solid_queue (background jobs)
- Potential additions:
  - redcarpet or kramdown (markdown rendering) - ✅ Already installed
  - rouge (code/recipe syntax highlighting) - ✅ Already installed

## Success Metrics

- User engagement: Average messages per chat session
- Recipe discovery: Number of recipes saved from chat
- Guardrail effectiveness: % of non-cooking queries properly handled
- User satisfaction: Feedback/ratings on recipe suggestions
- Retention: Users returning to chat feature
