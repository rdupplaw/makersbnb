feature 'registering a new user' do
  scenario 'a new user is added to the db' do
    visit('/users/register')
    fill_in(:email, with: 'email@gmail.com')
    fill_in(:password, with: 'password')
    click_button('Submit')

    expect(current_path).to eq('/listings')

    connection = PG.connect(dbname: 'makersbnb_test')
    result = connection.exec('SELECT * FROM users')
    expect(result.first['email']).to eq('email@gmail.com')
  end
end