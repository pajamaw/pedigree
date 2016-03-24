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
    paternal_grandfather_if_present
    paternal_grandmother_if_present
  end

  def maternal_grandparents
    maternal_grandfather_if_present
    maternal_grandmother_if_present
  end

  def paternal_grandfather_if_present
    if father.father_id !=nil
      @grandpad = father.father
    end
    rescue
      false
  end

  def paternal_grandmother_if_present
    if father.mother_id !=nil
      @grandmad = father.mother
    end
    rescue
     false
  end

  def maternal_grandfather_if_present
    if mother.father_id !=nil
      @grandpam = mother.father
    end
    rescue
      false
  end

  def maternal_grandmother_if_present
    if mother.mother_id !=nil
      @grandmam = mother.mother
    end
    rescue
      false
  end


  def sibling
    @sibling = []
    if father_if_present != "N/A"
      Individual.all.each do |t|
        if t.father_id == father_id
          @sibling << t unless t == self
        end
      end
    elsif mother_if_present != "N/A"
     Individual.all.each do |t|
        if t.mother_id == mother_id
          @sibling << t unless t == self
        end
      end
    end
      @siblings = @sibling.uniq
      @siblings
  end


  #####children methods######
  def run_gcif?
    if gender.downcase.strip == "m" 
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
    if gender.downcase.strip == "m"
      father_children_if_present
    else
      mother_children_if_present
    end
  end

  def father_children_if_present
    if childs_father == []
      "N/A"
    else
       childs_father
    end
      rescue
    "N/A"
  end

  def mother_children_if_present
    if childs_mother == []
      "N/A"
    else
       childs_mother
    end
     rescue
    "N/A"
  end

  ####end of children methods######

  ####parent and spouse helper methods######
  def father_if_present
    if father_id == nil
     "N/A"
    else
       @dad_id = father.id
       father.name
    end
  rescue
    "N/A"
  end

  def mother_if_present
    if mother_id ==nil
      "N/A"
    else
      @mom_id = mother.id
      mother.name
    end
     rescue
    "N/A"
  end

  def spouse_if_present
    if spouse_id == nil
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