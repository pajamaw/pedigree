class FamilyTree < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :user
  has_many :individuals
end