feature 'Viewing listings' do
  scenario 'A user can see a page of listings' do
    Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99)
    Listing.create(name: 'test name 2', description: 'test description 2', price: 99.99)
    Listing.create(name: 'test name 3', description: 'test description 3', price: 79.99)

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
