require 'rubygems'
require 'sinatra'
require 'sqlite3'

db = SQLite3::Database.new("theBoards.db")

get '/about/?' do
  "about the pinboard tool."
end

get '/boards/?' do
  # "a list of the boards"
  rows = db.execute( "select name from boards" )
  rows[0]
end

# deliver a board json
get %r{/boards/(.*)\.json} do
  rows = db.execute( "select data from boards where name='#{params[:captures].first}'" )
end

# save an update to the DB.
put %r{/boards/(.*)\.json} do
  db.execute( "update boards set data='#{params[:board]}' where name='#{params[:captures].first}'" )
  "I just did this: update boards set data='#{params[:board]}' where name='#{params[:captures].first}'"
end

# deliver a board with UI
get %r{/boards/([\w]+)} do
  rows = db.execute( "select data from boards where name='#{params[:captures].first}'" )
  @title =  "#{params[:captures].first}" 
  @data = rows[0]
  erb :index
end


