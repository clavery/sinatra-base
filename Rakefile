#!/usr/bin/env ruby
# Rakefile for the password manager application
# Most administrative functions can be done with this
# including exporting credentials, adding/changing a master
# passphrase, etc
#
# See Gemfile for the rubygems that are required for this application
# As long as you have the bundle gem you can "bundle install" to get these

require 'rubygems'
require 'sequel'
require 'highline/import'
require 'pp'

DB = Sequel.connect ENV['DATABASE_URL'] ? ENV['DATABASE_URL'] : 'sqlite://database.db'

require './models'

namespace :db do
  desc "setup database from ./database or perform needed migrations"
  task :migrate do
    db = ENV['DATABASE_URL'] ? ENV['DATABASE_URL'] : 'sqlite://database.db'
    sh "sequel -m database #{db}"
  end

  desc 'open the IRB console with models loaded'
  task :console do
    db = ENV['DATABASE_URL'] ? ENV['DATABASE_URL'] : 'sqlite://database.db'
    sh "sequel -I . -r models.rb #{db}"
  end
end

namespace :user do

  desc 'add a user'
  task :add do
    username = ask("Username: ")
    password = ask("Password: ") { |q| q.echo = false }
    is_admin = ask("Type yes for admin") { |q| q.default = "no" }

    if is_admin =~ /(y|Y)es/
      is_admin = true
    else
      is_admin = false
    end

    user = User.new
    user.username = username
    user.password = password
    user.is_admin = is_admin
    user.save

    pp user
  end

  desc 'remove a user'
  task :remove do
    username = ask("Username: ")

    user = User.first :username => username

    if user.nil?
      puts "User not found"
      return
    end

    proceed = ask("Are you sure you want to do this? Type yes if so. ") { |q| q.default = "no" }
    if proceed == "yes"
      user.destroy
      puts "User #{user.username} deleted."
      pp user
    end
  end

  desc 'change password for a user'
  task :passwd do
    username = ask("Username: ")
    user = User.first :username => username

    if user.nil?
      puts "User not found"
      return
    end

    password = ask("Password: ") { |q| q.echo = false }
    user.password = password
    user.save
    puts "User #{user.username} password changed"
  end

end
