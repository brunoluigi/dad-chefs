class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [ :search ]

  def index
    @recipes = current_user.recipes
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def search
    if params[:q].present?
      user_prompt = "User query: #{params[:q]}\n\n"

      response = RubyLLM.chat.ask(user_prompt, provider: :openai)

      if response.content.strip == "NOT_COOKING_RELATED"
        @recipes = []
        @error_message = "I appreciate your question, but I'm specialized in helping parents find healthy and practical recipes for their kids. I can only assist with food and cooking-related queries. Please ask me about recipes, meal ideas, or cooking tips, and I'll be happy to help!"
      else
        @recipes = response.content.split("\n").map { |title| Recipe.new(title: title) }
      end
    else
      @recipes = []
    end
  end

  def save
    @recipe = Recipe.find_or_create_by(title: params[:title])
    current_user.recipes << @recipe
    redirect_to recipes_path, notice: "Recipe saved to your cookbook!"
  end
end
