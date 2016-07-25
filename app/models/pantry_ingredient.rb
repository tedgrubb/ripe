class PantryIngredient < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :pantry
  
  validates_uniqueness_of :ingredient_id, :scope => :pantry_id
  
  after_create :set_expires_at
  named_scope :expired, :conditions => ['expires_at < ?', Time.now]
  
private
  
  def set_expires_at
    category = self.ingredient.categories.last
    # if the ingredient has a category use the default keep time
    if category && category.keep_time
      keep_time = category.keep_time
    else
      # otherwise just set it to 300 days
      keep_time = 300
    end
    self.expires_at = Time.now + keep_time.days
    self.save!
  end
  
end
