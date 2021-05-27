# frozen_string_literal: true

feature 'logging a user out' do
  # need to test for invalid email / passwords
  scenario 'it clears a user from the session' do
    register_new_user
    click_button('Sign out')

    expect(page).not_to have_content('Hello, email@gmail.com')
  end
end
