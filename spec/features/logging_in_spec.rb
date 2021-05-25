# feature 'logging in' do
#   scenario 'user is logged in' do
#     register_new_user

#     click_button('Sign out')
#     click_button('Sign in')

#     fill_in(:email, with: 'email@gmail.com')
#     fill_in(:password, with: 'password')
#     click_button('Submit')

#     expect(current_path).to eq('/listings')
#     expect(page).to have_content('Hello, email@gmail.com')
#   end
# end