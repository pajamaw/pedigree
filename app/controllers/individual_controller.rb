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
    if logged_in?
      @tree = FamilyTree.find_by_id(params[:id])
      erb :'individuals/new'
    else
      redirect "/"
    end
  end

  post "/family_trees/:id/individuals" do
    @tree = FamilyTree.find_by_id(params[:id])
    @individual = Individual.new(name: params[:individual_name], family_tree_id: @tree.id)
    if @individual.name == ""
      redirect "/family_trees/#{@tree.id}/individuals/new", locals: {message: "Please do not leave any fields blank."}
    else 
      @individual.save
      redirect "/family_trees/#{@tree.id}/individuals" 
    end
  end

  get '/family_trees/:id' do 
    if logged_in?
      @tree = FamilyTree.find_by_id(params[:id])
      erb :'family_trees/show'
    else
      redirect "/users/login"
    end
  end

  get '/family_trees/:id/edit' do 
    if logged_in?
      @tree = FamilyTree.find_by_id(params[:id])
      if @tree.user_id == session[:id]
        erb :'family_trees/edit'
      else
        redirect "/family_trees/#{@tree.id}"
      end
    else
      redirect "/users/login"
    end
  end

  patch "/family_trees/:id" do
    @tree = FamilyTree.find_by_id(params[:id])
    if params[:name].empty?
       redirect "/family_trees/#{@tree.id}/edit"
    else
      @tree.update(name: params[:name])
      redirect to "/family_trees/#{@tree.id}"
    end
  end

  delete "/family_trees/:id/delete" do
    if logged_in?
      @tree = FamilyTree.find_by_id(params[:id])
      if @tree.user_id == session[:id]
        @tree.delete
        redirect "/family_trees"
      else
        redirect "/family_trees/#{@tree.id}"
      end
    else
      redirect "/users/login"
    end
  end

end