feature 'Booking a space' do
  scenario 'requesting a space on a particular date' do
    listing = Listing.create(name: "Charlie's house", description: 'Super cool', price: '99.99')
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
end
