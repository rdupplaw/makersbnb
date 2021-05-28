# frozen_string_literal: true

feature 'Viewing listings' do
  scenario 'A user can see a page of listings' do
    user = User.register(email: 'test@example.com', password: 'password')
    Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99, owner_id: user.id,
                   start_date: '2021-05-27', end_date: '2021-05-28')
    Listing.create(name: 'test name 2', description: 'test description 2', price: 99.99, owner_id: user.id,
                   start_date: '2021-05-27', end_date: '2021-05-28')
    Listing.create(name: 'test name 3', description: 'test description 3', price: 79.99, owner_id: user.id,
                   start_date: '2021-05-27', end_date: '2021-05-28')

    visit '/listings'

    expect(page).to have_content('test name 1')
    expect(page).to have_content('test description 1')
    expect(page).to have_content('$89.99')
    expect(page).to have_content('test name 2')
    expect(page).to have_content('test description 2')
    expect(page).to have_content('$99.99')
    expect(page).to have_content('test name 3')
    expect(page).to have_content('test description 3')
    expect(page).to have_content('$79.99')
  end
end
