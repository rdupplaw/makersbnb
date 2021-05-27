# frozen_string_literal: true

feature 'registering a new user' do
  scenario 'a new user is added to the db' do
    register_new_user

    expect(current_path).to eq('/listings')

    expect(page).to have_content('Hello, email@gmail.com')
  end
end
