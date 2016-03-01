require './config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  helpers do
    def logged_in?
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end

    def belongs_to_you?
      current_user.id == @tree.user_id
    end

    def sibling
      @sibling = []
      @sibling = Individual.all.select do |t|
        t.father && t.mother
        end
      @sibling
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

  
