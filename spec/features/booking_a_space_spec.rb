# frozen_string_literal: true

feature 'Booking a space' do
  scenario 'requesting a space on a particular date' do
    user = User.register(email: 'test@example.com', password: 'password')
    listing = Listing.create(name: "Charlie's house", description: 'Super cool', price: '99.99', owner_id: user.id, start_date: '2021-05-27', end_date: '2021-05-28')
    register_new_user

    visit('/listings')
    expect(page).to have_content "Charlie's house"

    click_link(listing.name.to_s)

    fill_in('start_date', with: '2021-12-12')
    click_button 'Request Space'

    expect(current_path).to eq '/bookings'
    expect(page).to have_content "Charlie's house"
    expect(page).to have_content 'Not confirmed'
    expect(page).to have_content '2021-12-12'
  end

  scenario 'requesting a space when a booking exists on that date' do
    owner = User.register(email: 'test2@example.com', password: 'password123')
    user = User.register(email: 'test3@example.com', password: 'password123')
    listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99, owner_id: owner.id, start_date: '2021-05-27', end_date: '2021-05-28')
    booking = Booking.create(start_date: '2021-07-12', listing_id: listing.id, user_id: user.id)

    booking.accept

    register_new_user

    visit('/listings')
    click_link(listing.name.to_s)

    fill_in('start_date', with: '2021-07-12')
    click_button 'Request Space'

    expect(current_path).to eq("/listings/#{listing.id}")
    expect(page).to have_content('test name 1')
    expect(page).to have_content('test description 1')
    expect(page).to have_content('A booking already exists on this date')
  end
end
