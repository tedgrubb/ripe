require 'digest/sha1'

class User < ActiveRecord::Base
  def to_param
    "#{id}-#{login.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
  end 

  has_many  :pantry_memberships, :dependent => :destroy
  has_many  :pantries, :through => :pantry_memberships

  has_many  :grocery_list_memberships, :dependent => :destroy
  has_many  :grocery_lists, :through => :grocery_list_memberships
  
  has_many  :recipe_ratings, :dependent => :destroy
  has_many  :ratings, :through => :recipe_ratings, :uniq => true
  
  has_many  :daily_recommendations
  has_many  :favorite_recipes
  
  has_many  :recipe_comments, :dependent => :destroy
  has_many  :comments, :through => :recipe_comments  
  
  has_many  :cuisine_preferences, :dependent => :destroy
  has_many  :cuisines, :through => :cuisine_preferences
  
  has_one   :photo, :class_name => 'Photo', :as => :owner, :dependent => :destroy
  
  before_create :create_pantry, :give_invites
  before_create :create_grocery_list
  #after_create :send_new_user_email
  after_save :save_photo
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :case_sensitive => false
  validates_format_of       :login,    :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD

  validates_format_of       :name,     :with => RE_NAME_OK,  :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :uploaded_data, :location, :inviter_id, :favorite_food

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    u = find_by_email(email) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def name
    self.login
  end
  
  def possessive_name
    if self.login.ends_with? "s"
      self.login + "'"
    else 
      self.login + "'s"
    end
  end
  
  def send_new_user_email
    UserMailer.deliver_new_user(self)
  end
  
  def recommendation_score
    score = 0
    cuisine_score = self.cuisines && self.cuisines.any? ? 20 : 0
    if self.pantry.ingredients.count == 0
      score = 0
    elsif self.pantry.ingredients.count < 20
      score = 20 + cuisine_score
    elsif self.pantry.ingredients.count < 40
      score = 60 + cuisine_score
    elsif self.pantry.ingredients.count > 40
      score = 80 + cuisine_score
    end
    score
  end
  
  # AUTORIZATIONS
  
  def can_edit_user(user)
    self.id == user.id || self.is_admin?
  end
  
  def can_edit_recipe(recipe)
    self.id == recipe.user_id || self.is_admin?
  end
  
  def can_edit_grocery_list(grocery_list)
    self.grocery_list == grocery_list
  end
  
  def can_edit_pantry(pantry)
    self.pantry == pantry
  end
  
  def can_edit_comment(comment)
    self.id == comment.user_id || self.is_admin?
  end
  
  def can_edit_ingredient(ingredient)
    self.is_admin?
  end
  
  
  def is_admin?
    self.admin?
  end
  
  def pantry
    pantries.first
  end
  
  def pantry=(p)
    self.pantries = [p]
  end
  
  def grocery_list
    grocery_lists.first
  end
  
  def grocery_list=(g)
    self.grocery_lists = [g]
  end
  
  def photo_path(version)
    version ||= :large
    photo ? self.photo.public_filename(version) : default_photo_path(version)
  end
  
  def default_photo_path(version)
    "user-icon_#{version}.png"
  end
  
  def uploaded_data=(data)
    return if data.blank?
    self.photo ||= Photo.new(:owner => self)
    self.photo.uploaded_data = data
  end
  
  def recipes
    Recipe.find_all_by_user_id(self.id)
  end
  
  def can_make?(recipe)
    recipe_ingredients = recipe.ingredients
    recipe_count = recipe_ingredients.length
    user_count = (self.pantry.ingredients & recipe_ingredients).length
    recipe_count == user_count
  end
  
  def is_admin
    return self.login == "Ted"
  end
  
  def in_pantry(ingredient)
    self.pantry.ingredients.include?(ingredient)
  end
  
  def in_grocery_list(ingredient)
    self.grocery_list.ingredients.include?(ingredient)
  end
  
  def unfinished_recipes
    Recipe.find_all_by_user_id(self.id, :conditions => ["published = ?", false]) || []
  end
  
  private
  
  def create_pantry
    p = Pantry.new
    self.pantry = p
  end
  
  def create_grocery_list
    g = GroceryList.new
    self.grocery_list = g
  end
  
  def save_photo
    self.photo.save if self.photo
  end
  
  def give_invites
    self.invites = 5
  end
  
end
