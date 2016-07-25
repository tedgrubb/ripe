ActionController::Routing::Routes.draw do |map|

  def static_url(map, *names)
    names.each do |name|
      map.send name, name, :controller => 'static', :action => name
    end
  end
  
  static_url map, *%w( 
    about
    contact
    terms
  )
  
  map.logout    '/logout',    :controller => 'sessions',  :action => 'destroy'
  map.login     '/login',     :controller => 'sessions',  :action => 'new'
  map.register  '/register',  :controller => 'users',     :action => 'create'
  map.signup    '/signup',    :controller => 'users',     :action => 'new'
  
  map.resources :ingredients, :collection => {:search => :get, :insert => :get, :random => :get}
  map.resources :grocery_lists
  map.resources :categories
  map.resources :cuisines
  map.resources :invites
  map.resources :invite_requests
  map.resources :kitchen_tools
  map.resource :home, :controller => "home", :action => "show"

  map.resources :searches
  map.resource  :session
  
  map.resources :recipes, :member => {:ingredient_list => :post, :flickr_photos => :post}, :collection => {:random => :get} do |recipe|
    recipe.resources  :recipe_ratings,  :controller => "recipes/recipe_ratings"
    recipe.resources  :comments,        :controller => "recipes/recipe_comments"
    recipe.resources  :favorites,       :controller => "recipes/favorite_recipes"
    recipe.resource   :twitter,         :controller => 'recipes/twitters'
    recipe.resource   :follow,          :controller => "recipes/follow"
    recipe.resource   :email,           :controller => "recipes/email"
    recipe.resource   :make,            :controller => "recipes/make"
  end

  map.resource  :my, :controller => "my" do |my|
    my.resource   :home,            :controller => "my/home"
    my.resource   :pantry,          :controller => "my/pantry"
    my.resources  :groceries,       :controller => "my/groceries"
    my.resources  :recipes,         :controller => "my/recipes"
    my.resources  :favorites,       :controller => "my/favorites"
    my.resources  :daily_recipes,   :controller => "my/daily_recipes"
    my.resources  :recommendations, :controller => "my/recommendations"
  end

  map.resources :users do |user|
    user.resources :grocery_lists, :controller => 'users/grocery_lists' do |grocery_list|
      grocery_list.resources :ingredients, :controller => "users/grocery_lists/ingredients", :collection => {:add_recipe => :put, :search => :get, :insert => :get}, :member => {:checked_off => :post}
    end
    user.resource :pantry, :controller => 'users/pantries' do |pantry|
      pantry.resources :ingredients, :controller => "users/pantries/ingredients", :collection => {:search => :get, :insert => :get}
    end
    user.resources  :recipes, :controller => 'users/recipes'
    user.resource   :setup,   :controller => 'users/setup', :collection => {:ingredients => :get}
  end

  map.root :controller => 'root', :action => 'index'  
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
