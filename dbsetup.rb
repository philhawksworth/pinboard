require 'rubygems'
require 'sqlite3'

db = SQLite3::Database.new("theBoards.db")

# create the db table.
db.execute("create table boards (name TEXT, data BLOB)")

# create a board. This needs to be done via the UI soon.
jsonBlob = '{"title": "example", "modifier": "Phil Hawksworth", "modified": "14/4/2009 at 11:25", "categories": ["Ideas", "Tasks", "Done", "Shopping", "Notes"], "cards": [{"name": "A smaller idea", "categories": "Ideas"}, {"name": "A big idea", "categories": "Ideas"}, {"name": "That thing I should do", "categories": "Tasks"}, {"name": "That thing I did", "categories": "Done"}, {"name": "Buy milk", "categories": "Shopping"}]}'
db.execute( "insert into boards (name, data) values ('example', '" + jsonBlob + "')")
