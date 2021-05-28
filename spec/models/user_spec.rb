# frozen_string_literal: true

require 'user'

describe User do
  describe '::register' do
    it 'registers a new user' do
      user = User.register(email: 'email@gmail.com', password: 'password')
      connection = PG.connect(dbname: 'makersbnb_test')
      result = connection.exec('SELECT * FROM users')
      expect(result.first['email']).to eq(user.email)
    end

    it 'hashes the password using BCrypt' do
      expect(BCrypt::Password).to receive(:create).with('password')

      User.register(email: 'email@gmail.com', password: 'password')
    end
  end

  describe '::find' do
    it 'returns a user from a user id' do
      result = User.register(email: 'email@gmail.com', password: 'password')
      user = User.find(result.id)

      expect(result.email).to eq(user.email)
    end
  end

  describe '::authenticate' do
    it 'returns the user id given the correct email and password' do
      result = User.register(email: 'email@gmail.com', password: 'password')
      user = User.authenticate('email@gmail.com', 'password')
      expect(user.id).to eq(result.id)
    end
    it 'returns nil with incorrect password' do
      result = User.register(email: 'email@gmail.com', password: 'password')
      expect(User.authenticate('email@gmail.com', 'password1')).to be_nil
    end
    it 'returns nil with incorrect email' do
      result = User.register(email: 'email@gmail.com', password: 'password')
      expect(User.authenticate('email123@gmail.com', 'password')).to be_nil
    end
  end
end
