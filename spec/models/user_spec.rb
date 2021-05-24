require 'user'

describe User do
  describe '::register' do
    it 'registers a new user' do
      User.register(email: 'email@gmail.com', password: 'password')
      connection = PG.connect(dbname: 'makersbnb_test')
      result = connection.exec('SELECT * FROM users')
      expect(result.first['email']).to eq('email@gmail.com')
    end
  end  
end