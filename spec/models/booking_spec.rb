require 'booking'
require 'listing'
require 'user'

describe Booking do
  describe '::where' do
    it 'returns all bookings for a specified user id' do
      listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99)
      user = User.register(email: 'test@example.com', password: 'password123')
      other_user = User.register(email: 'test2@example.com', password: 'password123')

      booking1 = Booking.create(start_date: '2021-07-12', listing_id: listing.id, user_id: user.id)
      booking2 = Booking.create(start_date: '2021-08-12', listing_id: listing.id, user_id: other_user.id)
      booking3 = Booking.create(start_date: '2021-09-12', listing_id: listing.id, user_id: user.id)

      bookings = Booking.where(user_id: user.id)

      expect(bookings.length).to eq(2)
      expect(bookings.first).to be_a(Booking)
      expect(bookings.first.id).to eq(booking1.id)
      expect(bookings.first.start_date).to eq('2021-07-12')
      expect(bookings.first.listing_id).to eq(listing.id)
      expect(bookings.first.user_id).to eq(user.id)
    end
  end

  describe '::create' do
    it 'creates a new Booking object' do
      listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99)
      user = User.register(email: 'test@example.com', password: 'password123')

      booking = Booking.create(start_date: '2021-07-12', listing_id: listing.id, user_id: user.id)
      persisted_data = PG.connect(dbname: 'makersbnb_test').exec_params('SELECT * FROM bookings WHERE id=$1',
                                                                        [booking.id])

      expect(booking.id).to eq(persisted_data[0]['id'])
      expect(booking.start_date).to eq('2021-07-12')
      expect(booking.listing_id).to eq(listing.id)
      expect(booking.user_id).to eq(user.id)
      expect(booking.confirmed).to be_nil
    end
  end
end
