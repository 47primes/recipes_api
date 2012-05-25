class Recipe < ActiveRecord::Base
  belongs_to :cook
  belongs_to :cookbook
  
  attr_accessible :cook, :name, :category, :directions, :ingredients
  
  validates_presence_of :cook_id, :name, :directions, :ingredients
end
