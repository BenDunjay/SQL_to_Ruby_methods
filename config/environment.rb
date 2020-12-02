require "bundler"
Bundler.require

require_relative "../lib/user.rb"

DB = { :conn => SQLite3::Database.new("db/users.db") }
