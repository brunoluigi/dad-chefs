class ListRecipesTool < RubyLLM::Tool
  description "List all recipes in the user cookbook. Return a list in a nice Markdown format"

  def initialize(current_user)
    @current_user = current_user
  end

  def execute
    @current_user.recipes.pluck(:id, :title)
  end
end
