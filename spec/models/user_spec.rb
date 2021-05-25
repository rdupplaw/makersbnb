require 'user'

describe User do
  describe '::register' do
    it 'registers a new user' do
      user = User.register(email: 'email@gmail.com', password: 'password')
      connection = PG.connect(dbname: 'makersbnb_test')
      result = connection.exec('SELECT * FROM users')
      expect(result.first['email']).to eq(user.email)
    end
  end 

  describe '::find' do
    it 'returns a user from a user id' do
      result = User.register(email: 'email@gmail.com', password: 'password')
      user = User.find(result.id)

      expect(result.email).to eq(user.email)
    end
  end
end