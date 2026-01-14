# Cookbook Feature Specification - Save Recipe to My Cookbook

## User Stories

### Primary User Stories
- **As a** logged-in user, **I want to** save recipes to my cookbook **so that** I can find them later and access my personal collection
- **As a** logged-in user, **I want to** organize my saved recipes with tags and categories **so that** I can quickly find recipes for specific occasions or dietary needs
- **As a** logged-in user, **I want to** remove recipes from my cookbook **so that** I can keep my collection relevant and organized
- **As a** logged-in user, **I want to** search within my cookbook **so that** I can quickly find specific recipes without browsing through everything
- **As a** logged-in user, **I want to** save recipes from chat suggestions **so that** I can preserve AI-generated recipe recommendations

### Secondary User Stories
- **As a** logged-in user, **I want to** see which recipes I've already saved **so that** I don't accidentally save duplicates
- **As a** logged-in user, **I want to** edit saved recipes **so that** I can customize them to my preferences
- **As a** logged-in user, **I want to** add personal notes to recipes **so that** I can remember modifications or cooking tips

## Overview
The Cookbook feature allows authenticated users to save recipes to their personal cookbook collection. Users can save recipes from search results, recipe details, and chat suggestions, creating a personalized collection of recipes they can access and manage.

## Current Implementation Status

### ✅ What's Already Built

#### Models & Data Layer
- **User Model** ([app/models/user.rb](../app/models/user.rb))
  - ✅ `has_many :cookbooks` association
  - ✅ `has_many :recipes, through: :cookbooks` association
  - ✅ Devise authentication with magic links

- **Recipe Model** ([app/models/recipe.rb](../app/models/recipe.rb))
  - ✅ `has_many :cookbooks` association
  - ✅ `has_many :users, through: :cookbooks` association
  - ✅ Attributes: `title`, `ingredients`, `instructions`, `source_url`

- **Cookbook Model** ([app/models/cookbook.rb](../app/models/cookbook.rb))
  - ✅ Join table between User and Recipe
  - ✅ `belongs_to :user` and `belongs_to :recipe`
  - ✅ Acts as many-to-many relationship

#### Controllers
- **RecipesController** ([app/controllers/recipes_controller.rb](../app/controllers/recipes_controller.rb))
  - ✅ `index` - Display user's saved recipes
  - ✅ `show` - Display recipe details
  - ✅ `search` - Search for recipes using AI
  - ✅ `save` - Save recipe to user's cookbook (basic implementation)

#### Routes
- ✅ `resources :recipes` with standard RESTful routes

## Acceptance Criteria

### AC1: Save Recipe to Cookbook
**Given** I'm logged in and viewing a recipe (from search, details, or chat)
**When** I click "Save to Cookbook"
**Then** the recipe appears in my cookbook collection
**And** I see a success message "Recipe saved to your cookbook!"
**And** the save button changes to "Already Saved"

### AC2: Duplicate Prevention
**Given** I've already saved a recipe to my cookbook
**When** I try to save the same recipe again
**Then** I see an error message "Recipe is already in your cookbook"
**And** no duplicate entry is created in the database
**And** the save button shows "Already Saved" state

### AC3: Remove Recipe from Cookbook
**Given** I'm viewing my cookbook and a recipe is saved
**When** I click "Remove from Cookbook"
**Then** the recipe is removed from my cookbook
**And** I see a success message "Recipe removed from your cookbook"
**And** the recipe no longer appears in my cookbook list

### AC4: Search Within Cookbook
**Given** I'm viewing my cookbook with multiple recipes
**When** I enter search terms in the cookbook search box
**Then** I see only recipes matching my search terms
**And** the search works across recipe titles, ingredients, and instructions

### AC5: Save Recipe from Chat
**Given** I'm in a chat conversation and receive a recipe suggestion
**When** I click "Save to Cookbook" next to the recipe
**Then** the recipe is extracted and saved to my cookbook
**And** I can view the full recipe details in my cookbook

## 🔧 What Needs to Be Implemented

### High Priority

#### 1. Enhanced Recipe Saving Functionality
**Status:** ⚠️ Basic implementation exists, needs enhancement

**Definition of Done:**
- [ ] `RecipesController#save` handles full recipe details (title, ingredients, instructions, source_url)
- [ ] Duplicate prevention with user-friendly error messages
- [ ] Proper recipe creation with all attributes validated
- [ ] Success/error flash messages for save operations
- [ ] Recipe updates handled when same recipe is saved with different details
- [ ] Unit tests for save action with valid/invalid data
- [ ] Integration tests for duplicate prevention
- [ ] UI tests for save button state changes

**Current Issues:**
- The `save` action in RecipesController is too basic
- No validation for duplicate saves
- Missing recipe details (ingredients, instructions) when saving from search
- No user feedback for save status

#### 2. Cookbook Management Interface
**Status:** ❌ Not implemented

**Definition of Done:**
- [ ] Dedicated CookbooksController created with proper routing
- [ ] `index` action shows user's cookbook with all saved recipes
- [ ] `destroy` action removes recipes from cookbook with confirmation
- [ ] Basic recipe organization (categories, tags) implemented
- [ ] Search/filter within user's cookbook functional
- [ ] Pagination for cookbook with many recipes (20 recipes per page)
- [ ] Controller tests for all actions
- [ ] Integration tests for user scope enforcement
- [ ] System tests for full user workflow

**What's Needed:**
- [ ] Create dedicated CookbooksController
- [ ] Add `index` action to show user's cookbook with all saved recipes
- [ ] Add `destroy` action to remove recipes from cookbook
- [ ] Add recipe organization features (categories, tags, favorites)
- [ ] Implement search/filter within user's cookbook
- [ ] Add pagination for cookbook with many recipes

#### 3. Recipe Save UI Components
**Status:** ❌ Not implemented

**Definition of Done:**
- [ ] "Save to Cookbook" buttons functional on recipe show page
- [ ] Save buttons working on search results page with proper state management
- [ ] Save buttons implemented in chat for recipe suggestions
- [ ] Visual indicators for already saved recipes (button state changes)
- [ ] Save confirmation tooltips and error messages displayed
- [ ] "Remove from Cookbook" buttons functional for saved recipes
- [ ] All UI components responsive on mobile devices
- [ ] JavaScript tests for button state management
- [ ] Accessibility tests for keyboard navigation

**What's Needed:**
- [ ] Add "Save to Cookbook" buttons on recipe show page
- [ ] Add save buttons on search results page
- [ ] Implement save buttons in chat for recipe suggestions
- [ ] Add visual indicators for already saved recipes
- [ ] Create save confirmation modals/tooltips
- [ ] Add "Remove from Cookbook" buttons for saved recipes

#### 4. Recipe Details Enhancement
**Status:** ⚠️ Partially implemented

**Current Issues:**
- Recipe search only returns titles, missing full recipe details
- No recipe editing capability
- Missing recipe metadata (cooking time, difficulty, servings)

**What's Needed:**
- [ ] Enhance AI search to return full recipe details
- [ ] Add recipe editing functionality for saved recipes
- [ ] Add recipe metadata fields (cooking_time, difficulty, servings, cuisine_type)
- [ ] Implement recipe image support
- [ ] Add nutritional information tracking

### Medium Priority

#### 5. Recipe Organization Features
**Status:** ❌ Not implemented

**What's Needed:**
- [ ] Add recipe categories (breakfast, lunch, dinner, snacks, desserts)
- [ ] Implement tagging system (dietary restrictions, cuisine types, cooking methods)
- [ ] Add favorites/bookmarking functionality
- [ ] Create recipe collections/playlists
- [ ] Add meal planning integration

#### 6. Cookbook Sharing & Export
**Status:** ❌ Not implemented

**What's Needed:**
- [ ] Add cookbook sharing functionality
- [ ] Implement export to PDF/print
- [ ] Add email recipe feature
- [ ] Create public cookbook profiles
- [ ] Add social media sharing buttons

#### 7. Advanced Search & Filtering
**Status:** ❌ Not implemented

**What's Needed:**
- [ ] Add advanced search within cookbook
- [ ] Filter by dietary restrictions, cooking time, difficulty
- [ ] Sort by various criteria (date saved, title, cooking time)
- [ ] Add recipe recommendation engine based on saved recipes
- [ ] Implement "similar recipes" suggestions

### Low Priority

#### 8. Recipe Interaction Features
**Status:** ❌ Not implemented

**What's Needed:**
- [ ] Add recipe ratings and reviews
- [ ] Implement cooking notes/comments for personal recipes
- [ ] Add "cooked this" tracking with dates
- [ ] Create recipe modification history
- [ ] Add ingredient shopping list generation

#### 9. Integration with Other Features
**Status:** ❌ Not implemented

**What's Needed:**
- [ ] Integrate with chat feature for recipe suggestions
- [ ] Add meal planning calendar integration
- [ ] Implement grocery list generation from cookbook recipes
- [ ] Add seasonal recipe recommendations
- [ ] Create recipe-of-the-day feature

## Implementation Phases

### Phase 1: Core Cookbook Functionality (Sprint 1-2)
**Goal:** Basic recipe saving and viewing functionality

**Stories & Points:**
- Save Recipe to Cookbook (5 points)
- View Cookbook Index (3 points) 
- Remove Recipe from Cookbook (2 points)

**Definition of Done for Phase 1:**
- [ ] Users can save recipes with duplicate prevention
- [ ] Users can view their cookbook with saved recipes
- [ ] Users can remove recipes from their cookbook
- [ ] All actions have proper authentication and authorization
- [ ] Success/error messages are displayed appropriately
- [ ] Unit and integration tests are passing
- [ ] UI is responsive and accessible

**Acceptance Criteria Met:** AC1, AC2, AC3

### Phase 2: Recipe Organization & Search (Sprint 3-4)
**Goal:** Enhanced cookbook management with organization features

**Stories & Points:**
- Search Within Cookbook (5 points)
- Recipe Categories (3 points)
- Recipe Tags (3 points)
- Cookbook Filtering (2 points)

**Definition of Done for Phase 2:**
- [ ] Users can search their cookbook by title, ingredients, instructions
- [ ] Users can categorize recipes (breakfast, lunch, dinner, etc.)
- [ ] Users can tag recipes with custom tags
- [ ] Users can filter cookbook by categories and tags
- [ ] Search and filtering work together seamlessly
- [ ] Performance is acceptable with 100+ recipes
- [ ] All tests pass including new feature tests

**Acceptance Criteria Met:** AC4

### Phase 3: Chat Integration & Advanced Features (Sprint 5-6)
**Goal:** Full integration with chat feature and advanced cookbook management

**Stories & Points:**
- Save Recipes from Chat (5 points)
- Recipe Editing (3 points)
- Personal Recipe Notes (2 points)
- Cookbook Export (3 points)

**Definition of Done for Phase 3:**
- [ ] Users can save recipe suggestions from chat conversations
- [ ] Users can edit saved recipes in their cookbook
- [ ] Users can add personal notes to saved recipes
- [ ] Users can export their cookbook to PDF
- [ ] All chat-cookbook integrations work smoothly
- [ ] Advanced features have proper error handling
- [ ] Full test coverage including edge cases

**Acceptance Criteria Met:** AC5

### Phase 4: Polish & Optimization (Sprint 7)
**Goal:** Performance optimization and user experience refinements

**Stories & Points:**
- Performance Optimization (3 points)
- Mobile UX Improvements (2 points)
- Accessibility Enhancements (2 points)

**Definition of Done for Phase 4:**
- [ ] Cookbook pages load in under 200ms
- [ ] Mobile experience is fully optimized
- [ ] Accessibility compliance (WCAG 2.1 AA) achieved
- [ ] All user feedback from testing is addressed
- [ ] Production deployment ready

## Detailed Implementation Plan

### Phase 1: Core Cookbook Functionality

#### 1.1 Enhanced RecipesController
```ruby
# app/controllers/recipes_controller.rb enhancements needed:

def save
  @recipe = Recipe.find_or_initialize_by(title: recipe_params[:title])
  
  if @recipe.new_record?
    @recipe.assign_attributes(recipe_params)
    unless @recipe.save
      redirect_back(fallback_location: root_path, alert: "Failed to save recipe: #{@recipe.errors.full_messages.join(', ')}")
      return
    end
  end
  
  cookbook_entry = current_user.cookbooks.find_or_initialize_by(recipe: @recipe)
  
  if cookbook_entry.new_record?
    if cookbook_entry.save
      redirect_back(fallback_location: recipe_path(@recipe), notice: "Recipe saved to your cookbook!")
    else
      redirect_back(fallback_location: root_path, alert: "Failed to save recipe to cookbook.")
    end
  else
    redirect_back(fallback_location: recipe_path(@recipe), alert: "Recipe is already in your cookbook.")
  end
end

private

def recipe_params
  params.require(:recipe).permit(:title, :ingredients, :instructions, :source_url, :cooking_time, :difficulty, :servings)
end
```

#### 1.2 CookbooksController
```ruby
# New controller needed:
class CookbooksController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @recipes = current_user.recipes.includes(:cookbooks)
    @categories = @recipes.distinct.pluck(:category).compact
  end
  
  def destroy
    @cookbook = current_user.cookbooks.find(params[:id])
    @cookbook.destroy
    redirect_to cookbook_path, notice: "Recipe removed from your cookbook."
  end
end
```

#### 1.3 UI Components
- [ ] Recipe save buttons with state management
- [ ] Cookbook index page with recipe cards
- [ ] Recipe removal confirmations
- [ ] Success/error message displays

### Phase 2: Recipe Organization

#### 2.1 Recipe Model Enhancements
```ruby
# Add to Recipe model:
class Recipe < ApplicationRecord
  # ... existing code ...
  
  enum category: { breakfast: 0, lunch: 1, dinner: 2, snack: 3, dessert: 4, drink: 5 }
  enum difficulty: { easy: 0, medium: 1, hard: 2 }
  
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  
  validates :title, presence: true
  validates :ingredients, presence: true, on: :complete_recipe
  validates :instructions, presence: true, on: :complete_recipe
end
```

#### 2.2 Tagging System
```ruby
# New models needed:
class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :recipes, through: :taggings
  
  validates :name, presence: true, uniqueness: true
end

class Tagging < ApplicationRecord
  belongs_to :recipe
  belongs_to :tag
  
  validates :recipe_id, uniqueness: { scope: :tag_id }
end
```

### Phase 3: Advanced Features

#### 3.1 Recipe Search Enhancement
- [ ] Improve AI search to return structured recipe data
- [ ] Add recipe parsing from chat messages
- [ ] Implement recipe similarity matching

#### 3.2 User Experience Enhancements
- [ ] Add recipe preview modals
- [ ] Implement drag-and-drop recipe organization
- [ ] Add keyboard shortcuts for cookbook navigation
- [ ] Create recipe quick-save functionality

## Testing Requirements

### Unit Tests (Model Layer)
**Recipe Model Tests** (`test/models/recipe_test.rb`)
- [ ] Test presence validations for title, ingredients, instructions
- [ ] Test associations with cookbooks and users
- [ ] Test scopes for categories and difficulty levels
- [ ] Test tagging functionality (acts_as_taggable)
- [ ] Test recipe search by title and ingredients
- [ ] Test custom methods for recipe completion status

**Cookbook Model Tests** (`test/models/cookbook_test.rb`)
- [ ] Test belongs_to associations for user and recipe
- [ ] Test uniqueness validation for user-recipe combination
- [ ] Test dependent destruction behavior
- [ ] Test custom scopes for user cookbook queries
- [ ] Test methods for checking recipe save status

**User Model Tests** (`test/models/user_test.rb`)
- [ ] Test has_many relationships with cookbooks and recipes
- [ ] Test cookbook management methods
- [ ] Test recipe saving and removal methods
- [ ] Test custom queries for user's cookbook

**Tag Model Tests** (`test/models/tag_test.rb`)
- [ ] Test tag creation and validation
- [ ] Test recipe-tag associations through taggings
- [ ] Test tag normalization and case handling
- [ ] Test custom scopes for popular tags

### Controller Tests (Request Layer)
**RecipesController Tests** (`test/controllers/recipes_controller_test.rb`)
- [ ] Test save action with valid recipe data
- [ ] Test save action with duplicate prevention
- [ ] Test save action with invalid data (missing required fields)
- [ ] Test authentication requirements for all actions
- [ ] Test user scope enforcement (users can only save to their own cookbook)
- [ ] Test JSON responses for AJAX requests
- [ ] Test redirect behavior after save operations

**CookbooksController Tests** (`test/controllers/cookbooks_controller_test.rb`)
- [ ] Test index action with recipe listing
- [ ] Test index action with search filtering
- [ ] Test index action with category filtering
- [ ] Test destroy action with proper authorization
- [ ] Test authentication requirements for all actions
- [ ] Test pagination behavior for large cookbook collections
- [ ] Test user scope enforcement (users only see their own recipes)

### Integration Tests (Feature Layer)
**Recipe Saving Feature Tests** (`test/integration/recipe_saving_test.rb`)
- [ ] Test complete recipe saving flow from search results
- [ ] Test recipe saving from recipe details page
- [ ] Test recipe saving from chat suggestions
- [ ] Test duplicate prevention across different save methods
- [ ] Test error handling for failed save operations
- [ ] Test success message display and flash behavior

**Cookbook Management Feature Tests** (`test/integration/cookbook_management_test.rb`)
- [ ] Test cookbook index page with recipe listing
- [ ] Test recipe removal from cookbook with confirmation
- [ ] Test cookbook search functionality
- [ ] Test cookbook filtering by categories and tags
- [ ] Test pagination navigation for large cookbooks
- [ ] Test responsive behavior on mobile devices

**User Authentication Integration Tests** (`test/integration/authentication_test.rb`)
- [ ] Test unauthenticated users cannot access cookbook features
- [ ] Test users can only access their own cookbook
- [ ] Test session management for cookbook operations
- [ ] Test cross-user data isolation

### System Tests (End-to-End Layer)
**Full User Journey Tests** (`test/system/cookbook_journey_test.rb`)
- [ ] Test complete user journey: search → save → view → manage
- [ ] Test JavaScript save button state changes without page reload
- [ ] Test modal interactions for recipe removal confirmations
- [ ] Test dynamic search filtering with real-time updates
- [ ] Test responsive design on mobile and tablet devices
- [ ] Test keyboard navigation and accessibility compliance

**Performance Tests** (`test/system/performance_test.rb`)
- [ ] Test cookbook loading time with 100+ recipes
- [ ] Test search response time with large cookbook
- [ ] Test concurrent user cookbook operations
- [ ] Test memory usage during cookbook operations

**Security Tests** (`test/system/security_test.rb`)
- [ ] Test SQL injection prevention in search
- [ ] Test XSS prevention in recipe content
- [ ] Test CSRF protection for cookbook operations
- [ ] Test authorization bypass attempts

## Technical Considerations

### Performance
- [ ] Implement database indexing for cookbook queries
- [ ] Add pagination for large cookbook collections
- [ ] Consider caching for frequently accessed recipes
- [ ] Optimize recipe search queries

### Security
- [ ] Ensure all cookbook actions require authentication ✅
- [ ] Validate users can only access their own cookbook entries ✅
- [ ] Sanitize recipe input to prevent XSS
- [ ] Implement rate limiting for recipe saves

### Data Integrity
- [ ] Handle recipe deletion when users have saved it
- [ ] Implement soft deletes for recipes
- [ ] Add data validation for recipe imports
- [ ] Handle concurrent recipe saves gracefully

### Scalability
- [ ] Design for large numbers of recipes per user
- [ ] Consider sharding for high-volume usage
- [ ] Implement background job processing for recipe parsing
- [ ] Add monitoring for cookbook feature usage

## API Considerations

### Future API Endpoints
```ruby
# Potential future API routes:
namespace :api do
  namespace :v1 do
    resources :cookbooks, only: [:index, :show, :create, :destroy] do
      collection do
        get :search
        get :categories
      end
    end
    
    resources :recipes, only: [:show] do
      member do
        post :save
        delete :unsave
      end
    end
  end
end
```

### Mobile App Support
- [ ] Design API endpoints for mobile consumption
- [ ] Add offline recipe caching considerations
- [ ] Implement push notifications for recipe suggestions

## Success Metrics

### User Engagement
- Number of recipes saved per user
- Frequency of cookbook access
- Recipe removal rate (indicates quality of saves)
- Time spent on cookbook pages

### Feature Adoption
- Percentage of users who save recipes
- Recipe save sources (search, chat, manual)
- Tag and category usage rates
- Search within cookbook usage

### Content Quality
- Recipe completion rate (recipes with full details)
- User-generated recipe modifications
- Recipe sharing frequency
- Recipe rating distribution

## Dependencies

### Current Dependencies
- ✅ Rails 8.1
- ✅ Devise (authentication)
- ✅ PostgreSQL (database)
- ✅ TailwindCSS (styling)

### Potential Additions
- [ ] Active Storage (recipe images)
- [ ] Elasticsearch (advanced search)
- [ ] Sidekiq (background job processing)
- [ ] PgSearch (PostgreSQL full-text search)
- [ ] ActsAsTaggableOn (tagging system)

## Future Enhancements (Beyond Current Scope)

### AI-Powered Features
- Recipe recommendation engine
- Automatic recipe categorization
- Ingredient substitution suggestions
- Nutritional analysis integration

### Social Features
- Community recipe sharing
- Recipe comments and reviews
- User following and cookbook discovery
- Collaborative cooking planning

### Advanced Organization
- Meal planning calendar
- Grocery list generation
- Seasonal recipe recommendations
- Cooking schedule optimization

### Integration Opportunities
- Grocery delivery service APIs
- Kitchen appliance smart home integration
- Nutrition tracking app connections
- Social media recipe sharing

---

## Implementation Priority Summary

### Phase 1 (Immediate - Core Functionality)
1. ✅ Enhance RecipesController#save with duplicate prevention
2. ✅ Create CookbooksController with basic CRUD
3. ✅ Add save/remove UI buttons
4. ✅ Implement proper flash messaging

### Phase 2 (Short-term - Organization)
1. Add recipe categories and tags
2. Implement cookbook search and filtering
3. Add recipe editing capabilities
4. Create recipe detail enhancements

### Phase 3 (Medium-term - Advanced Features)
1. Add recipe sharing and export
2. Implement meal planning integration
3. Add recipe ratings and reviews
4. Create mobile-responsive design improvements

This specification provides a comprehensive roadmap for implementing the cookbook feature while maintaining consistency with the existing DadChefs application architecture and following Rails best practices.