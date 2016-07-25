module IngredientsHelper
  
  def ingredient_photo(ingredient, version)
    image = image_tag(ingredient.photo_path(version), :class => "photo", :alt => "")
    content_tag(:div, "<div>#{image}</div>", :class => "photo_wrap")
  end
  
  def ingredient_category_list(ingredient)
    category = ingredient.categories.first()
    return if category.blank?
    content_tag(:p, link_to(category.name.gsub(/\&/, "&amp;"), category_path(category)), :class => "category")
  end
  
  def freshomatic(pantry_ingredient, show_label = true)
    expires_at = pantry_ingredient.expires_at
    if expires_at != nil
      created_at = pantry_ingredient.created_at
      if expires_at > Time.now
        days_old = ((Time.now - created_at)/1.day)
        expiration = (expires_at-Time.now)/1.day
        percent_complete = (days_old+1)/expiration
        range = (8*percent_complete).to_i-1
        freshness = "_#{range}"
        time_label = "#{distance_of_time_in_words_to_now(expires_at)} left"
      else
        freshness = "_9"
        time_label = partial("my/pantry/ingredients/expired", :ingredient => pantry_ingredient.ingredient) if show_label
      end
      
      html_pie = content_tag :div, "", :class => "fresh-o-matic #{freshness}", :style => "float:left;"
      html_time = show_label ? content_tag(:div, time_label, :style => "color:#777;font-size: 90%;padding-top:6px;text-indent:6px") : ""
      content_tag :div, "#{html_pie}#{html_time}", :class => "clearfix"
    end
  end
  
end
