feature 'logging in' do
  scenario 'with correct email or password' do
    register_new_user

    click_button('Sign out')
    click_button('Sign in')

    fill_in(:email, with: 'email@gmail.com')
    fill_in(:password, with: 'password')
    click_button('Submit')

    expect(current_path).to eq('/listings')
    expect(page).to have_content('Hello, email@gmail.com')
  end

  scenario 'with incorrect email or password' do
    register_new_user

    click_button('Sign out')
    click_button('Sign in')

    fill_in(:email, with: 'email@gmail.com')
    fill_in(:password, with: 'password1')
    click_button('Submit')

    expect(current_path).to eq('/sessions/new')
    expect(page).to have_content('Incorrect email or password')
  end
end