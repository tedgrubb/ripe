module HomeHelper

  def grocery_list_status
    if @user.grocery_list.ingredients.empty?
      content_tag :p, "Start a #{link_to "<strong>grocery list</strong>", user_grocery_lists_path(@user)} to keep your pantry stocked."
    else
      content_tag :p, "#{link_to "<strong>#{pluralize(@user.grocery_list.ingredients.count, "item")}</strong>", user_grocery_lists_path(@user)} on your grocery list.", :class => "grocery_count"
    end
  end
  
  def pantry_status
    if @user.pantry.available_recipes.empty?
      content_tag :p, "#{link_to "<strong>Start adding ingredients</strong>", ingredients_path} to get recipe recommendations."
    else
      available_recipes = @user.pantry.available_recipes.length
      content_tag :p, "#{link_to_function "<strong>#{available_recipes} recipes</strong>", "Effect.ScrollTo('recipes', {duration: 0.4, transition: Effect.Transitions.sinoidal})"} you can make right now!", :class => "recipe_count"
    end
  end
  
  def recipes_status
    unless @user.unfinished_recipes.empty?
      path = @user.unfinished_recipes.length == 1 ? recipe_path(@user.unfinished_recipes.first) : user_recipes_path(@user)
      content_tag :p, "#{link_to "<strong>#{pluralize @user.unfinished_recipes.length, 'recipe'}</strong>", path} to finish publishing.", :class => "recipe_count"
    end
  end
  
end