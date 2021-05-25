
require 'bcrypt'

class User
  def self.register(email:, password:)
    dbname = ENV['RACK_ENV'] == 'test' ? 'makersbnb_test' : 'makersbnb'
    connection = PG.connect(dbname: dbname)
    encrypted_password = BCrypt::Password.create(password)
    result = connection.exec("INSERT INTO users (email, password) VALUES('#{email}', '#{encrypted_password}')
    RETURNING id, email")
    User.new(result.first['id'], result.first['email'])
  end

  def self.find(user_id)
    dbname = ENV['RACK_ENV'] == 'test' ? 'makersbnb_test' : 'makersbnb'
    connection = PG.connect(dbname: dbname)
    result = connection.exec("SELECT * FROM users WHERE id = '#{user_id}'")
    User.new(result.first['id'], result.first['email'])
  end

  attr_reader :id, :email

  def initialize(id, email)
    @id = id
    @email = email
  end
end
