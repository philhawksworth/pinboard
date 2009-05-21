require 'rubygems'
require 'sinatra'
require 'sqlite3'

db = SQLite3::Database.new("theBoards.db")

# create the db table if it doesn;t already exist.
db.execute("create table if not exists boards (name TEXT, data BLOB) ")

# create an example board. if there isn't one already.
example = db.execute("select * from boards where name='example'")
if example.size == 0
  jsonBlob = '{"title": "example", "modifier": "Phil Hawksworth", "modified": "14/4/2009 at 11:25", "categories": ["Ideas", "Tasks", "Done", "Shopping", "Notes"], "cards": [{"name": "A smaller idea", "categories": "Ideas"}, {"name": "A big idea", "categories": "Ideas"}, {"name": "That thing I should do", "categories": "Tasks"}, {"name": "That thing I did", "categories": "Done"}, {"name": "Buy milk", "categories": "Shopping"}]}'
  db.execute( "insert into boards (name, data) values ('example', '" + jsonBlob + "')")
end



get '/?' do
  erb :home
end

get '/boards/?' do
  # "a list of the boards"
  rows = db.execute( "select name from boards" )  
  links = ""
  rows.map{|row| links = links + "<li><a href='/boards/"+ row[0] +"'>"+ row[0] +"</a></li>"}
  @boards = links
  erb :listing
end

# create a new board
post '/boards/?' do
  name = "#{params[:name]}"
  jsonBlob = '{"title": "'+ name +'", "modifier": "AN Other", "modified": "brand new!", "categories": ["Hot", "Not"], "cards": [{"name": "Paris", "categories": "Hot"}, {"name": "Paris Hilton", "categories": "Not"}]}'
  db.execute( "insert into boards (name, data) values ('#{params[:name]}', '" + jsonBlob + "')" )
  redirect "/boards/" + "#{params[:name]}"
end


# delete a board
delete %r{/boards/([\w]+)} do
  name = "#{params[:captures].first}"  
  db.execute( 'delete from boards where name="'+ name +'"' )
end


# deliver a board json
get %r{/boards/(.*)\.json} do
  rows = db.execute( "select data from boards where name='#{params[:captures].first}'" )
  rows[0]
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


