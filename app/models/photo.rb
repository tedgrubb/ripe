class Photo < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true

  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 3.megabyte,
                 :resize_to => '640x480>',
                 :thumbnails => {:thumbnail => '75x', :small => '55x55>', :medium => '100x100>', :large => '140x140>', :full_medium => "250x" }

  validates_as_attachment

end
