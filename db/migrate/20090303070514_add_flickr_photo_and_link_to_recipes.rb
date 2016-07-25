class AddFlickrPhotoAndLinkToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :flickr_photo, :string
    add_column :recipes, :flickr_photo_link, :string
  end

  def self.down
    remove_column :recipes, :flickr_photo_link
    remove_column :recipes, :flickr_photo
  end
end
