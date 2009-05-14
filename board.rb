require 'rubygems'
require 'sinatra'
require 'sqlite3'

db = SQLite3::Database.new("theBoards.db")

get '/about/?' do
  "about theboard tool."
end

get '/boards/?' do
  # "a list of the boards"
  rows = db.execute( "select name from boards" )
  rows[0]
end

# deliver a board json
get %r{/boards/(.*)\.json} do
  rows = db.execute( "select data from boards where name='prospects'" )
  rows[0]  
end

# save an update to the DB.
put %r{/boards/(.*)\.json} do
  
 # data= params[:board]
  
  db.execute( "update boards set data='#{params[:board]}' where name='#{params[:captures].first}'" )
  "I just did this: update boards set data='#{params[:board]}' where name='#{params[:captures].first}'"
end

# deliver a board with UI
get %r{/boards/([\w]+)} do
  rows = db.execute( "select data from boards where name='prospects'" )
  @title =  "#{params[:captures].first}" 
  @data = rows[0]
  # @data = '{
  #   "title": "Prospects",
  #   "modifier": "Phil Hawksorth",
  #   "modified": "5/4/2009 at 16:12",
  #   "categories": ["questioning", "thinking", "designing", "building", "delivery"],
  #   "cards" : [
  #     {"name": "theteam website", "category": "designing"},
  #     {"name": "Fat Duck", "category": "designing"},
  #     {"name": "NHS", "category": "questioning"},
  #     {"name": "Becta phase 1", "category": "building"}
  #   ]
  # }'  
  erb :index
end


