require 'rubygems'
require 'sqlite3'

db = SQLite3::Database.new("theBoards.db")

# creat the db table.
db.execute("create table boards (name TEXT, data BLOB)")

# create a board. This needs to be done via the UI soon.
db.execute( "insert into boards (name, data) values ('prospects', 'foo, bar, baz')")
