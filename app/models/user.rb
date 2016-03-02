class User < ActiveRecord::Base
  include Slugifiable
  extend Slugifiable 
  validates_presence_of :username, :password
  has_secure_password
  has_many :family_trees
  has_many :individuals, through: :family_trees
end 


# so how it should actually go 