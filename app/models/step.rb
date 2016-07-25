class Step < ActiveRecord::Base
  belongs_to  :recipe
  has_one   :photo, :class_name => 'Photo', :as => :owner, :dependent => :destroy
  after_create :save_photo
  
  def photo_path(version)
    photo ? self.photo.public_filename(version) : "ingredient_#{version}.png"
  end
  
  def uploaded_data=(data)
    return if data.blank?
    self.photo ||= Photo.new(:owner => self)
    self.photo.uploaded_data = data
  end
  
  def to_cooking_json
    {:number => self.number, :description => self.description}
  end
  
  private
  def save_photo
    self.photo.save if self.photo
  end
end