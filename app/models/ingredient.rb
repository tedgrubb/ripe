class Ingredient < ActiveRecord::Base
  def to_param
    "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
  end
  
  #acts_as_solr :fields => [:name]
  
  has_many    :ingredient_categories, :dependent => :destroy
  has_many    :pantry_ingredients, :dependent => :destroy
  has_many    :recipe_ingredients, :dependent => :destroy

  has_many    :categories, :through => :ingredient_categories
  has_many    :recipes, :through => :recipe_ingredients
  has_many    :pantries,   :through => :pantry_ingredients
  has_one     :photo, :class_name => 'Photo', :as => :owner, :dependent => :destroy

  attr_accessor :new_categories
  # after_save :solr_save, :save_photo
  # after_destroy :solr_destroy
  
  #validates_presence_of :categories
  
  def food_group=(group)
    category = Category.find_by_name(group)
    self.categories << category if category
  end
  
  def save_with_categories!
    transaction do
      save!
      create_category_associations
    end
  end
  
  def photo_path(version)
    photo ? self.photo.public_filename(version) : "ingredient_#{version}.png"
  end
  
  def photo_url(version)
    photo ? "http://#{DEFAULT_HOST}#{self.photo.public_filename(version)}" : "http://#{DEFAULT_HOST}/images/ingredient_#{version}.png"
  end
  
  def uploaded_data=(data)
    return if data.blank?
    self.photo ||= Photo.new(:owner => self)
    self.photo.uploaded_data = data
  end
  
  def save_with_categories
    save_with_categories!
  rescue ActiveRecord::RecordInvalid
    false
  end

  def self.import(path)
    data = YAML.load(open(path))
    data.each do |c|
      ingredient = Ingredient.new(c)
      ingredient.save_with_categories!
    end
  end
  
  def self.find_by_param!(name)
    record = find(:first, :conditions => {:name => name})
    raise ActiveRecord::RecordNotFound if record.nil?
    record
  end
  
  private
  def create_category_associations
    categories =  case @new_categories 
                  when String then @new_categories.split(",")
                  when Array then @new_categories
                  else
                    []
                  end
    self.ingredient_categories.destroy_all if categories.any?      
    categories.each do |category|
      IngredientCategory.create!(:ingredient => self, :category_id => category)
    end
  end
  
  def save_photo
    self.photo.save if self.photo
  end

end
