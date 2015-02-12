require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require "better_errors"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

# this will store your users
users = []

# this will store an id to user for your users
# you'll need to increment it every time you add
# a new user, but don't decrement it
id = 1

# routes to implement:
#
# GET / - show all users
get '/' do
  @users = users
  erb :index
end

# GET /users/new - display a form for making a new user
get '/users/new' do
  erb :new
  #the 'create user' on the form is linked to post the users with the method specified in the form "post??"
end
# POST /users - create a user based on params from form
# how is this linked to the previously empty form?? it calls the 'post' method and redirects here?
post '/users' do
	users.push first:params[:first], last:params[:last], id: id
	id = id + 1
	redirect '/'
	#what is the way in the networks tab to see the post?
end
# GET /users/:id - show a user's info by their id, this should display the info in a form
get '/users/:id' do
	users.each do |user| 
		if user[:id] == params[:id].to_i
			@user = user
		end
	end		
		erb :user
		#are parameters always strings?
		#this then takes you to the user.erb page? why no redirect to the page?
end
# PUT /users/:id - update a user's info based on the form from GET /users/:id
put '/users/:id' do
	user = users[params[:id].to_i - 1]
	user[:first] = params[:first]
	user[:last] = params[:last]
  
  redirect '/'
end
# DELETE /users/:id - delete a user by their id
delete '/users/:id' do

	user =  users.find{|user| user[:id] == params[:id].to_i} 
#need to look more into the details of the 'find' method
	users.delete(user) 
 	redirect '/' 
 
end
#WHY was it deleting the previous user from the one selected and WHY wouldn't it delete the user if it was the last one in the list? (obviously the two are intertwined because it was targeting user + 1, so user would never be deleted but WTF?)
