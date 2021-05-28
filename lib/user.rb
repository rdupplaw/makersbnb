# frozen_string_literal: true

require 'bcrypt'

class User
  def self.register(email:, password:)
    encrypted_password = BCrypt::Password.create(password)
    result = DatabaseConnection.query_params("INSERT INTO users (email, password) VALUES($1, $2)
    RETURNING id, email", [email, encrypted_password])
    User.new(result.first['id'], result.first['email'])
  end

  def self.find(user_id)
    result = DatabaseConnection.query("SELECT * FROM users WHERE id = '#{user_id}'")
    User.new(result.first['id'], result.first['email'])
  end

  def self.authenticate(email, password)
    user = DatabaseConnection.query_params('SELECT * FROM users WHERE email = $1', [email])
    return unless user.any?
    return unless BCrypt::Password.new(user.first['password']) == password

    User.new(user.first['id'], user.first['email'])
  end

  attr_reader :id, :email

  def initialize(id, email)
    @id = id
    @email = email
  end
end
