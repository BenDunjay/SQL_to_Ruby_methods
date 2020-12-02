require "./config/environment.rb"
require "./lib/user.rb"

User.create_table
user = User.create("Ben", 20)
p user.name
p user.id
