# frozen_string_literal: true

feature 'Confirming a request' do
  scenario 'A user can confirm an incoming request' do
    requester = User.register(email: 'requester@example.com', password: 'password')
    owner = User.register(email: 'owner@example.com', password: 'password')
    listing = Listing.create(name: 'Test Listing', description: 'Test Description', price: 99.99, owner_id: owner.id)
    booking = Booking.create(start_date: '2021-12-12', listing_id: listing.id, user_id: requester.id)

    visit '/listings'
    click_button('Sign in')
    fill_in(:email, with: 'owner@example.com')
    fill_in(:password, with: 'password')
    click_button('Submit')

    visit '/bookings'
    click_link('Test Listing')

    expect(current_path).to eq("/bookings/#{booking.id}")
    expect(page).to have_content("Request for '#{listing.name}'")
    expect(page).to have_content("From: #{requester.email}")
    expect(page).to have_content("Date: #{booking.start_date}")

    click_button("Confirm request from #{requester.email}")

    expect(current_path).to eq('/bookings')
    expect(page).to have_content listing.name
    expect(page).to have_content 'Confirmed'
    expect(page).to have_content booking.start_date
  end
end
