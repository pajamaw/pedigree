class IndividualController < ApplicationController


  ['/family_trees/:id/individuals', '/family_trees/:id/individuals/'].each do |path|
    get path do
      if logged_in?
        @individuals = []
        @tree = FamilyTree.find_by_id(params[:id])
        Individual.all.each do |t|
          if t.family_tree_id == @tree.id
            @individuals << t
          end
        end
        @individuals
        erb :'individuals/index'
      else
        redirect "/family_trees/:id"
      end
    end
  end  

  get "/family_trees/:id/individuals/new" do 
    @tree = FamilyTree.find_by_id(params[:id])
    if logged_in? && belongs_to_you?
      erb :'individuals/new'
    else
      redirect '/users/failure'
    end
  end

  post "/family_trees/:id/individuals" do
    @tree = FamilyTree.find_by_id(params[:id])
    @individual = Individual.find_or_create_by(name: params[:individual][:name], gender: params[:individual][:gender], family_tree_id: @tree.id)
    @father = Individual.find_or_create_by(name: params[:individual][:father_name], gender: params[:individual][:father_gender], family_tree_id: @tree.id) unless params[:individual][:father_name] == "" || params[:individual][:father_gender] == nil
        if @father
          @individual.father_id = @father.id
        end
    @mother = Individual.find_or_create_by(name: params[:individual][:mother_name], gender: params[:individual][:mother_gender], family_tree_id: @tree.id) unless params[:individual][:mother_name] == "" || params[:individual][:mother_gender] == nil
        if @mother
          @individual.mother_id = @mother.id
        end
    @spouse = Individual.find_or_create_by(name: params[:individual][:spouse_name], gender: params[:individual][:spouse_gender], family_tree_id: @tree.id) unless params[:individual][:spouse_name] == "" || params[:individual][:spouse_gender] == nil
        if @spouse
          @individual.spouse_id = @spouse.id
          @spouse.spouse_id = @individual.id
          @spouse.update(spouse_id: @individual.id)
        end
    if !(@individual.name != "" || @individual.gender != "")
        @individual.delete
      redirect "/family_trees/#{@tree.id}/individuals/new", locals: {message: "Please do not leave the name or gender field blank for the individual."}
    else 
      @individual.save
      redirect "/family_trees/#{@tree.id}/individuals" 
    end
  end

  get '/family_trees/:id/individuals/:id' do 
    if logged_in?
      @individual = Individual.find_by_id(params[:id])
      @tree = FamilyTree.find_by_id(@individual.family_tree_id)
      erb :'individuals/show'
    else
      redirect "/users/login"
    end
  end

  get '/family_trees/:id/individuals/:id/edit' do 
    if logged_in?
      @individual = Individual.find_by_id(params[:id])
      @tree = FamilyTree.find_by_id(@individual.family_tree_id)
      if @tree.user_id == session[:id]
        erb :'individuals/edit'
      else
        redirect "/family_trees/#{@tree.id}/individuals/#{@individual.id}"
      end
    else
      redirect "/users/login"
    end
  end

  patch "/family_trees/:id/individuals/:id" do
    @individual = Individual.find_by_id(params[:id])
    @tree = FamilyTree.find_by_id(@individual.family_tree_id)

    if params[:individual][:name] == ""
      redirect "/family_trees/#{@tree.id}/individuals/#{@individual.id}/edit", locals: {message: "Please do not leave any fields blank."}
    else
      
      @individual.update(name: params[:individual][:name])
      redirect to "/family_trees/#{@tree.id}/individuals"
    end
  end

  delete "/family_trees/:id/individuals/:id/delete" do
    if logged_in?
    @individual = Individual.find_by_id(params[:id])
    @tree = FamilyTree.find_by_id(@individual.family_tree_id)
      if @tree.user_id == session[:id]
        @individual.delete
        redirect "/family_trees/#{@tree.id}/individuals"
      else
        redirect "/family_trees/#{@tree.id}/individuals/#{@individual.id}"
      end
    else
      redirect "/users/login"
    end
  end


  helpers do 


    ##Grandparents methods##
    def paternal_grandparents
      paternal_grandfather_if_present
      paternal_grandmother_if_present
    end

    def maternal_grandparents
      maternal_grandfather_if_present
      maternal_grandmother_if_present
    end

    def paternal_grandfather_if_present
      if @individual.father.father_id !=nil
        @grandpad = @individual.father.father
      end
      rescue
        false
    end

    def paternal_grandmother_if_present
      if @individual.father.mother_id !=nil
        @grandmad = @individual.father.mother
      end
      rescue
       false
    end

    def maternal_grandfather_if_present
      if @individual.mother.father_id !=nil
        @grandpam = @individual.mother.father
      end
      rescue
        false
    end

    def maternal_grandmother_if_present
      if @individual.mother.mother_id !=nil
        @grandmam = @individual.mother.mother
      end
      rescue
        false
    end


    def sibling
      @sibling = []
      if father_if_present != "N/A"
        Individual.all.each do |t|
          if t.father_id == @individual.father_id
            @sibling << t unless t == @individual
          end
        end
      elsif mother_if_present != "N/A"
       Individual.all.each do |t|
          if t.mother_id == @individual.mother_id
            @sibling << t unless t == @individual
          end
        end
      end
        @siblings = @sibling.uniq
        @siblings
    end


    #####children methods######
    def run_gcif?
      if @individual.gender.downcase.strip == "m" 
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
      if @individual.gender.downcase.strip == "m"
        father_children_if_present
      else
        mother_children_if_present
      end
    end

    def father_children_if_present
      if @individual.childs_father == []
        "N/A"
      else
         @individual.childs_father
      end
    end

    def mother_children_if_present
      if @individual.childs_mother == []
        "N/A"
      else
         @individual.childs_mother
      end
    end

    ####end of children methods######

    ####parent and spouse helper methods######
    def father_if_present
      if @individual.father_id ==nil
        "N/A"
      else
        @dad_id = @individual.father.id
        @individual.father.name
      end
    end

    def mother_if_present
      if @individual.mother_id ==nil
        "N/A"
      else
        @mom_id = @individual.mother.id
        @individual.mother.name
      end
    end

    def spouse_if_present
      if @individual.spouse_id == nil
        "N/A"
      else
        @honey_id = @individual.spouse.id
        @individual.spouse.name
      end
    end
    #####end of parent and spouse helper methods#######

    def warmup_methods
      father_if_present
      mother_if_present
      spouse_if_present
      gender_children_if_present
    end

    
    #def grandfather?(individual)
     # @grandparents =[]
      #@fparent_generation = individual.father
      #@mparent_generation = individual.mother 
      #if @fparent_generation.father != nil
       #  @fgrandparent = @fparent_generation.father
        #@grandparents << @fparent_generation
      #else
       # @fparent_generation.
      #end
      #if @mparent_generation.mother != nil
      #  @grandparents << mparent_generation
      #end 
    #end
  end

end