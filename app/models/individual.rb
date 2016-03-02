class Individual < ActiveRecord::Base
  validates_presence_of :name, :gender

  belongs_to :family_tree
  has_many :spouse, class_name: "Individual", foreign_key: "spouse_id"
  has_many :childs_father, class_name: "Individual", foreign_key: "father_id"
  has_many :childs_mother, class_name: "Individual", foreign_key: "mother_id"
  belongs_to :mother, class_name: "Individual"
  belongs_to :father, class_name: "Individual"
  belongs_to :spouse, class_name: "Individual"
end