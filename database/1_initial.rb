#!/usr/bin/env ruby
# Database schema with migrations
# This sets up the initial database

require 'sequel'

Sequel.migration do
  change do
    # access to the app only, meaningless for decryption
    create_table :users do
      primary_key :id
      String :username
      String :password
      TrueClass :is_admin, :default => false
    end

    create_table :foobars do
      primary_key :id
      String :name
    end
  end
end
