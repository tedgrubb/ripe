class Recipe < ActiveRecord::Base
  def to_param
    "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
  end 
  
  # acts_as_solr :fields => [
  #   {:name => {:boost => 1.5}},
  #   {:description => :text},
  #   {:user_id => :integer}
  # ]
  attr_accessor :new_ingredients, :new_steps, :new_cuisine
  # after_save :solr_save, :save_photo
  # after_destroy :solr_destroy
  
  has_many  :recipe_ingredients, :dependent => :destroy
  has_many  :ingredients, :through => :recipe_ingredients, :uniq => true
  
  has_many  :recipe_comments, :dependent => :destroy
  has_many  :comments, :through => :recipe_comments
  
  has_many  :daily_recommendations
  has_many  :favorite_recipes
  
  has_many  :recipe_ratings, :dependent => :destroy
  has_many  :ratings, :through => :recipe_ratings, :uniq => true
  
  has_one   :recipe_cuisine, :dependent => :destroy
  has_one   :cuisine, :through => :recipe_cuisine
  
  has_many  :steps, :dependent => :destroy
  has_one   :photo, :class_name => 'Photo', :as => :owner, :dependent => :destroy
  
  validates_presence_of :name

  def user
    User.find_by_id(self.user_id)
  end
  
  def rating
    self.recipe_ratings.average('score')
  end
  
  def save_with_associations!
    transaction do
      save!
      create_ingredient_associations
      create_steps
      create_cuisine
    end
  end
  
  def photo_path(version)
    photo ? self.photo.public_filename(version) : "/images/recipe_default_#{version}.png"
  end
  
  def has_photo?
    self.photo != nil
  end
  
  def has_flickr_photo?
    self.flickr_photo != nil && !self.flickr_photo.empty?
  end
  
  def has_any_photo?
    if self.has_photo? || self.has_flickr_photo?
      return true
    else
      return false
    end
  end
  
  def uploaded_data=(data)
    return if data.blank?
    self.photo = Photo.new(:owner => self)
    self.photo.uploaded_data = data    
  end
  
  def save_with_associations
    save_with_associations!
  rescue ActiveRecord::RecordInvalid
    false
  end
  
  def fraction_to_decimal(string)
    quantity = string.split(" ")
    if(quantity.size() > 1)
      whole_number = quantity.first().to_f
      fraction = quantity.last()
    end
    fraction ||= string
    whole_number ||= 0.0
    f = fraction.split("/")
    if(f.size() > 1)
      decimal = f.first().to_f/f.last().to_f
      whole_number+decimal
    else
      string.to_f
    end
  end
  
  def to_cooking_json
    {
      :name => self.name,
      :photo => "http://#{DEFAULT_HOST}#{self.photo_path(:large)}",
      :ingredients => self.recipe_ingredients.map{|recipe_ingredient| recipe_ingredient.to_cooking_json},
      :steps => self.steps.map{|step| step.to_cooking_json }
    }.to_json
  end
    
    
  # Find all recipe matches for a set of ingredients
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
  def self.for_ingredients(ingredients, options)
    return [] if ingredients.empty?
    
    limit = options[:limit] || nil
    
    recipe_ids = self.ids_for_ingredients(ingredients)
    Recipe.find(:all, :conditions => {:id => recipe_ids, :published => true}, :order => "created_at DESC")
  end
  
  def self.ids_for_ingredients(ingredients)
    Recipe.find(:all, 
      :select => 'recipes.id',
      :joins => "INNER JOIN  recipe_ingredients ON recipes.id = recipe_ingredients.recipe_id",
      :group => 'recipes.id, 
                 recipes.recipe_ingredients_count HAVING 
                 count(recipe_ingredients.id) = recipes.recipe_ingredients_count',
      :conditions => ['recipe_ingredients.ingredient_id in (?)', ingredients.map(&:id)]
    )
    
  end

  def can_make?(user)
    return false unless user
    recipe_ingredients = self.ingredients
    recipe_count = recipe_ingredients.length
    user_count = (user.pantry.ingredients & recipe_ingredients).length
    recipe_count == user_count
  end
  
  def favorite?(user)
    return false unless user
    user.favorite_recipes.find_by_recipe_id(self.id)
  end
  
  private
  
  def create_ingredient_associations
    ingredients = case @new_ingredients
                  when String then @new_ingredients.split(",")
                  when Array then @new_ingredients
                  when Hash then @new_ingredients
                  else
                    []
                  end
    self.recipe_ingredients.destroy_all if ingredients.any?     
    ingredients['ingredient_id'].each_with_index do |ingredient, i|
      RecipeIngredient.create!(
        :recipe => self, 
        :ingredient_id => ingredient, 
        :note => ingredients['note'][i],
        :measurement => ingredients['measurement'][i], 
        :entered_quantity => ingredients['entered_quantity'][i],
        :parsed_quantity => fraction_to_decimal(ingredients['entered_quantity'][i]))
    end
  end
  
  def create_steps
    self.steps.destroy_all if @new_steps.any?     
    @new_steps['number'].each_with_index do |step, i|
      Step.create!(
        :recipe => self,
        :number => @new_steps['number'][i], 
        :uploaded_data => @new_steps['uploaded_data'][i], 
        :description => @new_steps['description'][i])
    end
  end
  
  def create_cuisine
    self.recipe_cuisine.destroy if self.cuisine && !@new_cuisine.blank?
    RecipeCuisine.create!(
      :recipe => self,
      :cuisine_id => @new_cuisine
    )
  end
  
  def save_photo
    self.photo.save if self.photo
  end
  
end
