class FamilyTreeController < ApplicationController


  get "/family_trees" do 
    if logged_in?
      @trees = FamilyTree.all
      erb :'family_trees/index'
    else
      redirect "/"
    end
  end  

  get "/family_trees/new" do 
    if logged_in?
      erb :'family_trees/new'
    else
      redirect "/"
    end
  end

  post "/family_trees" do
    @tree = FamilyTree.new(name: params[:name], user_id: session[:id])
    if params[:name].empty? 
      redirect "/family_trees/new", locals: {message: "Please do not leave any fields blank."}
    else 
      @tree.save
      redirect "/family_trees" 
    end
  end

  get '/family_trees/:id' do 
    if logged_in?
      @individuals =[]
      @tree = FamilyTree.find_by_id(params[:id])
      @individuals = Individual.all.select do |t|
        if t.family_tree_id == @tree.id
         @individuals << t
        end
      end
      @individuals
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
        @theforgotten =[]
        @theforgotten = Individual.all.select do |individual| 
          individual.family_tree_id == @tree.id
        end
        if @theforgotten != []
          @theforgotten.each do |t|
            t.delete
          end
        end
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