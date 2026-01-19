class DeleteRecipeTool < RubyLLM::Tool
  description "Remove's a given user's recipe. Make sure you confirm with the user before calling this tool."

  params do
    integer :recipe_id, description: "ID of the recipe"
  end

  def initialize(current_user)
    @current_user = current_user
  end

  def execute(recipe_id:)
    @current_user.recipes.find(recipe_id).destroy!

    "Recipe deleted sucessfully"
  end
end
