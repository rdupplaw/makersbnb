# frozen_string_literal: true

def register_new_user
  visit('/users/new')
  fill_in(:email, with: 'email@gmail.com')
  fill_in(:password, with: 'password')
  click_button('Submit')
end
