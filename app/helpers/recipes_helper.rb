module RecipesHelper

  def matched_label(user_count, recipe_count)
    case user_count
    when recipe_count then "You have all #{pluralize(recipe_count, 'ingredient')}"
    else
      "You have #{user_count} of #{pluralize(recipe_count, 'ingredient')} "
    end
  end
  
  def recipe_meta_description(recipe, steps, ingredients)
    description = h strip_tags(recipe.description) unless recipe.description.blank?
    description ||= steps.map{|step| step.description}.join(", ")
    description ||= ingredients.map{|ri| ri.ingredient.name}.join(" | ")
    "<meta name=\"description\" content=\"#{truncate(description, 200)}\" />"
  end
  
  def recipe_creator_link(recipe)
    user = User.find_by_id(recipe.user_id)
    link_to user.login, user_path(user), :class => "author vcard fn"
  end
  
  def ingredometer_for(recipe)
    return unless current_user
    recipe_ingredients = recipe.ingredients
    recipe_count = recipe_ingredients.length
    user_count = (current_user.pantry.ingredients & recipe_ingredients).length
    content_tag :div, matched_label(user_count, recipe_count), :class => "ingredometer#{' checked' if user_count == recipe_count}"
  end
  # TODO: merge with ingredometer_for
  def ingredometer_icon(recipe)
    return unless current_user
    recipe_ingredients = recipe.ingredients
    recipe_count = recipe_ingredients.length
    user_count = (current_user.pantry.ingredients & recipe_ingredients).length
    if user_count == recipe_count
      content_tag :div, "&nbsp;", :class => "ingredometer#{' checked' if user_count == recipe_count}", :title => "You have all the ingredients"
    end
  end

  def grocery_list_link
    link_to_remote  "Add to Grocery List", 
                    :url => add_recipe_user_grocery_list_ingredients_path(current_user, current_user.grocery_list), 
                    :method => :put,
                    :with => "'recipe_id='+#{@recipe.id}",
                    :html => {:class => "add-grocery-list", :id => "add-link"}
  end
  
  def creator_info
    inner_content = if current_user && current_user.can_edit_recipe(@recipe)
      "You created this recipe so you can #{link_to 'edit', edit_recipe_path(@recipe)} or #{link_to 'delete it', @recipe, :confirm => 'Are you sure?', :method => :delete}"
    else
      "Created by #{recipe_creator_link(@recipe)} <abbr class=\"published\" title=\"#{@recipe.created_at}\">#{time_ago_in_words @recipe.created_at} ago</abbr>"
    end
    content_tag :p, inner_content, :class => "created_at"
  end
  
  def recipe_iframe
    "<iframe width=\"100%\" id=\"#{dom_id(@recipe)}\" scrolling=\"no\" height=\"900\" frameborder=\"0\" src=\"#{recipe_follow_path(@recipe)}\" allowtransparency=\"true\"/>"
  end

  def permalink(recipe, comment)
    recipe_url(recipe, :anchor => dom_id(comment))    
  end

  def recipe_meta(recipe)
    inner_content =   ""
    inner_content =   content_tag :small, "<strong>Time:</strong> #{recipe.time}&nbsp;&nbsp;&nbsp;" unless recipe.time.blank?
    inner_content +=  content_tag :small, "<strong>Cuisine:</strong> #{recipe.cuisine.name}&nbsp;&nbsp;&nbsp;" unless recipe.cuisine.blank?
    inner_content +=   content_tag :small, "<strong>Category:</strong> #{recipe.category}" unless recipe.category.blank?
    # Add more meta data here
    inner_content
  end
  
  def keywords(recipe)
    kw = recipe.name.split(" ")
    kw.push(recipe.category) unless recipe.category.blank?
    kw.join("%2C")
  end
  
  def recipe_comment_count(recipe)
    count = recipe.recipe_comments.count
    inner = case count
    when 0 then
      "No comments yet"
    else
      "#{count} comments"
    end
    content_tag :div, inner, :class => "comment_count"
  end

  def display_rating(recipe)
    rating = recipe.rating || 0
    stars = [1,2,3,4,5].map{|value|
      if value <= rating 
        partial("recipes/recipe_ratings/star", :recipe => recipe, :score => value.to_json, :on => true)
      else
        partial("recipes/recipe_ratings/star", :recipe => recipe, :score => value.to_json, :on => false)        
      end
    }
    counts = content_tag :span, "(based on #{pluralize(recipe.recipe_ratings.count, 'review')})" if recipe.recipe_ratings.count > 0
    content_tag :div, "#{stars} #{counts}", :id => dom_id(recipe, 'rating'), :class => "rating", :onmouseout => "reset_rating(this, #{rating})"
  end

  def ingredient_meta(ingredient, servings)
    #unit = unit_conversion(self.servings_quantity(ingredient, servings), ingredient.measurement)
    meta = []
    meta << "<span class=\"num\">#{self.servings_quantity(ingredient, servings)}</span>" if ingredient.entered_quantity
    meta << "<span class=\"unit\">#{ingredient.measurement.to_s}</span>" if ingredient.measurement
    meta << "(<span class=\"note\">#{ingredient.note}</span>)" unless ingredient.note.empty?
    content_tag :div, meta.join(" "), :class => "meta"
  end
  
  def servings_quantity(ingredient, servings)
    return ingredient.entered_quantity if servings.nil?
    
    multiplier    = (ingredient.parsed_quantity/@recipe.servings)
    raw_number    = (multiplier*servings).round(2)
    whole_number  = raw_number.to_i
    numerator     = raw_number - whole_number

    if numerator.to_s == '0.33' #check for 1/3
      fraction = [1,3]
    elsif numerator.to_s == '0.67' #check for 2/3
      fraction = [2,3]
    elsif numerator == 0.0
      fraction = [0,0]
    else
      fraction = numerator.to_fraction
    end
      
    
    if fraction[0] < fraction[1]
      if whole_number == 0
        "#{fraction[0]}/#{fraction[1]}"
      else        
        "#{whole_number} #{fraction[0]}/#{fraction[1]}"
      end
    else
      whole_number
    end
  end
  
  def unit_conversion(amount, measurement = "")
    
    unit = Unit.new("#{amount} #{clean_measurement(measurement)}")
    if unit.unitless? # No Unit. Can't be converted
      [unit, nil]
    elsif 1 == 2
      convert_unit_to_imperial(unit)
    else
      [amount, measurement]
    end
  rescue
    [amount, measurement]
  end
  
  def convert_unit_to_imperial(unit)
    end_unit = case unit.units
    when "cup", "tbs", "tsp", "oz" then unit.to("ml")
    end
    end_unit.to_s.split(" ")
  end
  
  def clean_measurement(m)
    return "" unless m
    case m.downcase
    when "tbsp" then "tbs"
    when "c." then "cup"
    when "graham" then "g"
    end
  end
  
  def servings_item(recipe, multiple)
    servings = (recipe.servings*multiple)
    link = link_to_remote "#{servings.to_i} <small>(x#{multiple})</small>", 
                          :url => ingredient_list_recipe_path(recipe), 
                          :with => "'servings='+#{servings}", 
                          :after => "$('change_servings').hide(); $('servings_dyn').update('#{servings}')"
    content_tag :li, link
  end

  def category_option(recipe, label)
    selected = @recipe.category == label ? "selected" : false
    "<option value='#{label}' #{"selected='selected'" if selected}>#{label}</option>"
  end

  def category_filter(category, label)
    selected = category == label ? "selected" : false
    "<option value='#{CGI::escape(label)}' #{"selected='selected'" if selected}>#{label.pluralize}</option>"
  end
  
  def cuisine_filter(current_cuisine, cuisine)
    selected = current_cuisine == cuisine.id ? "selected" : false
    category = params[:category] ? "?category=#{CGI::escape(params[:category])}" : ""
    "<option value='#{cuisine_path(cuisine)}#{category}' #{"selected='selected'" if selected}>#{cuisine.name}</option>"
  end

  def unpublished_notification
    if current_user && current_user.can_edit_recipe(@recipe)
      content_tag :div, "Your recipe has not been published. #{link_to 'Click here', edit_recipe_path(@recipe)} to continue where you left off.", :id => "unpublished_notification"
    end
  end
  
end
