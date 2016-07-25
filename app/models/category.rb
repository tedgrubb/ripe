class Category < ActiveRecord::Base
  def to_param
    "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
  end
  
  has_many    :ingredient_categories, :dependent => :destroy
  has_many    :ingredients, :through => :ingredient_categories

  
  def self.find_by_param(param)
    result = find_by_name(param); result ||= find_by_id(param)
  end
  
  
  def self.import(path)
    data = YAML.load(open(path))
    data.each do |c|
      Category.find_or_create_by_name(c)
    end
  end
  
  
end
