class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:search]

  def index
    @recipes = current_user.recipes
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def search
    if params[:q].present?
      prompt = "Suggest 5 recipe titles for kids based on the following query: #{params[:q]}. Return only the titles, separated by newlines."
      response = RubyLLM.chat.ask(prompt, provider: :openai)
      @recipes = response.content.split("\n").map { |title| Recipe.new(title: title) }
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
