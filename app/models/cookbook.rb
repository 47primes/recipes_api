class Cookbook < ActiveRecord::Base
  belongs_to :cook
  has_many :recipes
  
  attr_accessible :name, :description
  
  validates_presence_of :cook_id, :name
end
