# index.rss.builder
xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{@cuisine} Recipes"
    xml.description "#{@cuisine} Recipes on It's Ripe!"
    xml.link formatted_recipes_url(:rss)
    
    @recipes.each do |recipe|
      xml.item do
        xml.title recipe.name
        xml.description recipe.description
        xml.pubDate recipe.created_at.to_s(:rfc822)
        xml.link formatted_recipe_url(recipe, :rss)
        xml.guid formatted_recipe_url(recipe, :rss)
      end
    end
  end
end

  