class User
  def self.register(email:, password:)
    connection = PG.connect(dbname: 'makersbnb_test')
    result = connection.exec("INSERT INTO users (email, password) VALUES('#{email}', '#{password}')
    RETURNING id, email")
    User.new(result.first['id'], result.first['email'])
  end

  def self.find(user_id)
    connection = PG.connect(dbname: 'makersbnb_test')
    result = connection.exec("SELECT * FROM users WHERE id = '#{user_id}'")
    User.new(result.first['id'], result.first['email'])
  end

  attr_reader :id, :email

  def initialize(id, email)
    @id = id
    @email = email
  end
end
