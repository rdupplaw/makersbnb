class User
  def self.register(email:, password:)
    connection = PG.connect(dbname: 'makersbnb_test')
    connection.exec("INSERT INTO users (email, password) VALUES('#{email}', '#{password}') RETURNING id")
  end
end
