class RecipeIngredient < ActiveRecord::Base

  belongs_to :ingredient
  belongs_to :recipe, :counter_cache => true

  def to_cooking_json
    {:name => self.ingredient.name, :measurement => self.measurement, :quantity => self.entered_quantity, :small_photo => "#{self.ingredient.photo_url(:small)}", :large_photo => self.ingredient.photo_path(:large)}
  end

end
