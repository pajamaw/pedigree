class IndividualController < ApplicationController


  get "/family_trees/:id/individuals" do 
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

  get "/family_trees/:id/individuals/new" do 
    @tree = FamilyTree.find_by_id(params[:id])
    if logged_in? && belongs_to_you?
      erb :'individuals/new'
    else
      redirect '/users/failure'
    end
  end

  post "/family_trees/:id/individuals" do
    @individual = Individual.new(name: params[:individual_name], family_tree_id: @tree.id)
    @tree = FamilyTree.find_by_id(@individual.family_tree_id)
    if @individual.name == ""
      redirect "/family_trees/#{@tree.id}/individuals/new", locals: {message: "Please do not leave any fields blank."}
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

    if params[:individual_name] == ""
      redirect "/family_trees/#{@tree.id}/individuals/#{@individual.id}/edit", locals: {message: "Please do not leave any fields blank."}
    else
      @individual.update(name: params[:individual_name])
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

end