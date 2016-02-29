class FamilyTree < ActiveRecord::Base
  belongs_to :user
  has_many :individuals
end