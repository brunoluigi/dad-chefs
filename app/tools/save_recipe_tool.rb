class SaveRecipeTool < RubyLLM::Tool
  description "Saves recipe to the cookbook when user explicitly requests."

  params do
    string :title
    string :description
    array :ingredients do
      object {
        string :name
        string :quantity
      }
    end
    array :instructions, of: :string, description: "Instructions for preparing the meal"
    string :source_url, description: "Source URL where the recipe was pulled from", required: false
  end

  def initialize(current_user)
    @current_user = current_user
  end

  def execute(title:, description:, ingredients:, instructions:, source_url: nil)
    new_recipe = @current_user.recipes.build(title:, description:, ingredients:, instructions:, source_url:)

    if new_recipe.save
      "Recipe saved sucessfully!"
    else
      new_recipe.errors.full_messages
    end
  end
end
