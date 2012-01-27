require 'sequel'
require 'securerandom'
require 'bcrypt'

class User < Sequel::Model
  plugin :validation_helpers

  # authentication 
  def self.authenticate(username, password)
    user = User.filter(:username => username).first
    if user.nil?
      # prevent timing attacks if username is bad
      BCrypt::Password.create("garbage")
    else
      key = BCrypt::Password.new(user.password)
      unless key == password
        return nil
      end
    end
    user
  end

  def validate
    super
    validates_presence [ :username, :password ]
    validates_unique :username
  end

  def password=(value)
    super(BCrypt::Password.create(value))
  end
end

class Foobar < Sequel::Model

  plugin :validation_helpers

  def validate
    super
    validates_presence :name
  end
end
