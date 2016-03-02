# pedigree
A family tree pedigree project that works through an MVC Sinatra App using ActiveRecord with validations to ensure proper data input,  many-to-many relationships and isolated user accounts.  


everytime an individual is made. it can be a brother sister, cousin son. 

but all i need is the family

and the individual

every instance becomes a family member. you have to put in who is related to who. and every one creates a new instance. 

1. have to be able to define 
   grandfather
   grandmother
   aunt 
   uncle
   brother
   sister
   son 
   daughter 

   from starting point of 1 person

 2. things i have to use 
  individual.name
  individual.father
  individual.mother
  individual.spouse

  3. brother
    def sibling
      @sibling = []
      @sibling = Individual.all.collect do |t|
                  t.father && t.mother
                  end
                  end

