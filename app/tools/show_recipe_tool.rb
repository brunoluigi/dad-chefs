class ShowRecipeTool < RubyLLM::Tool
  description "Show details about a given user's recipe. Response is a JSON that should be displayed as a structured Markdown recipe"

  params do
    integer :recipe_id, description: "ID of the recipe"
  end

  def initialize(current_user)
    @current_user = current_user
  end

  def execute(recipe_id:)
    @current_user.recipes.find(recipe_id).to_json
  end
end
