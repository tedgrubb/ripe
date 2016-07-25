class KitchenTool < ActiveRecord::Base
  def to_param
    "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
  end
  #has_many :users :through => :users_kitchen_tools
  has_one :photo, :class_name => 'Photo', :as => :owner, :dependent => :destroy  
  
  def uploaded_data=(data)
    return if data.blank?
    self.photo ||= Photo.new(:owner => self)
    self.photo.uploaded_data = data
  end
  
  def photo_url(version)
    photo ? "http://#{DEFAULT_HOST}#{self.photo.public_filename(version)}" : "http://#{DEFAULT_HOST}/images/ingredient_#{version}.png"
  end
  
  def photo_path(version)
    photo ? self.photo.public_filename(version) : "ingredient_#{version}.png"
  end
  
  def self.find_by_param!(name)
    record = find(:first, :conditions => {:name => name})
    raise ActiveRecord::RecordNotFound if record.nil?
    record
  end
  
  
end