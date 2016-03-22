class Individual < ActiveRecord::Base
  validates_presence_of :name, :gender

  belongs_to :family_tree
  has_many :spouse, class_name: "Individual", foreign_key: "spouse_id"
  has_many :childs_father, class_name: "Individual", foreign_key: "father_id"
  has_many :childs_mother, class_name: "Individual", foreign_key: "mother_id"
  belongs_to :mother, class_name: "Individual"
  belongs_to :father, class_name: "Individual"
  belongs_to :spouse, class_name: "Individual"

 def paternal_grandparents
    self.paternal_grandfather_if_present
    self.paternal_grandmother_if_present
  end

  def maternal_grandparents
    self.maternal_grandfather_if_present
    self.maternal_grandmother_if_present
  end

  def paternal_grandfather_if_present
    if self.father.father_id !=nil
      @grandpad = self.father.father
    end
    rescue
      false
  end

  def paternal_grandmother_if_present
    if self.father.mother_id !=nil
      @grandmad = self.father.mother
    end
    rescue
     false
  end

  def maternal_grandfather_if_present
    if self.mother.father_id !=nil
      @grandpam = self.mother.father
    end
    rescue
      false
  end

  def maternal_grandmother_if_present
    if self.mother.mother_id !=nil
      @grandmam = self.mother.mother
    end
    rescue
      false
  end


  def sibling
    @sibling = []
    if self.father_if_present != "N/A"
      Individual.all.each do |t|
        if t.father_id == self.father_id
          @sibling << t unless t == self
        end
      end
    elsif self.mother_if_present != "N/A"
     Individual.all.each do |t|
        if t.mother_id == self.mother_id
          @sibling << t unless t == self
        end
      end
    end
      @siblings = @sibling.uniq
      @siblings
  end


  #####children methods######
  def run_gcif?
    if self.gender.downcase.strip == "m" 
      if father_children_if_present == "N/A"
        false
      else
        true
      end
    else
      if mother_children_if_present == "N/A"
        false
      else
        true
      end
    end
  end


  def gender_children_if_present
    if self.gender.downcase.strip == "m"
      father_children_if_present
    else
      mother_children_if_present
    end
  end

  def father_children_if_present
    if self.childs_father == []
      "N/A"
    else
       self.childs_father
    end
      rescue
    "N/A"
  end

  def mother_children_if_present
    if self.childs_mother == []
      "N/A"
    else
       self.childs_mother
    end
     rescue
    "N/A"
  end

  ####end of children methods######

  ####parent and spouse helper methods######
  def father_if_present
    if self.father_id == nil
     "N/A"
    else
       @dad_id = self.father.id
       self.father.name
    end
  rescue
    "N/A"
  end

  def mother_if_present
    if self.mother_id ==nil
      "N/A"
    else
      @mom_id = self.mother.id
      self.mother.name
    end
     rescue
    "N/A"
  end

  def spouse_if_present
    if self.spouse_id == nil
      "N/A"
    else
      @honey_id = self.spouse.id
      self.spouse.name
    end
     rescue
    "N/A"
  end
  #####end of parent and spouse helper methods#######

  def warmup_methods
    father_if_present
    mother_if_present
    spouse_if_present
    gender_children_if_present
  end
end