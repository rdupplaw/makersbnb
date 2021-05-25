require 'booking'
require 'listing'
require 'user'

describe Booking do
  describe '::create' do
    it 'creates a new Booking object' do
      p listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99)
      p user = User.register(email: 'test@example.com', password: 'password123')

      booking = Booking.create(start_date: '2021-07-12', listing_id: listing.id, user_id: user[0]['id'])
      persisted_data = PG.connect(dbname: 'makersbnb_test').exec_params('SELECT * FROM bookings WHERE id=$1',
                                                                        [booking.id])

      expect(booking.id).to eq(persisted_data[0]['id'])
      expect(booking.start_date).to eq('2021-07-12')
      expect(booking.listing_id).to eq(listing.id)
      expect(booking.user_id).to eq(user[0]['id'])
    end
  end
end
