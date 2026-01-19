class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :description
      t.jsonb :ingredients
      t.jsonb :instructions
      t.string :source_url

      t.timestamps
    end
  end
end
