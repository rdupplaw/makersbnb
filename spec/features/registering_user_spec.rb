feature 'registering a new user' do
  scenario 'a new user is added to the db' do
    visit('/users/new')
    fill_in(:email, with: 'email@gmail.com')
    fill_in(:password, with: 'password')
    click_button('Submit')

    expect(current_path).to eq('/listings')

    expect(page).to have_content('Hello, email@gmail.com')
  end
end