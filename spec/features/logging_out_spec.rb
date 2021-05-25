feature 'logging a user out' do
  # need to test for invalid email / passwords
  scenario 'it clears a user from the session' do
    visit('/users/new')
    fill_in(:email, with: 'email@gmail.com')
    fill_in(:password, with: 'password')
    click_button('Submit')

    click_button('Sign out')

    expect(page).not_to have_content('Hello, email@gmail.com')
  end
end