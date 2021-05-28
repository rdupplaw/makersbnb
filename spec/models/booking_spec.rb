# frozen_string_literal: true

require 'booking'
require 'listing'
require 'user'

describe Booking do
  describe '::where' do
    it 'returns all bookings for a specified user id' do
      owner = User.register(email: 'test2@example.com', password: 'password123')
      listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99,
                               owner_id: owner.id, start_date: '2021-05-27', end_date: '2021-05-28')
      user = User.register(email: 'test@example.com', password: 'password123')
      other_user = User.register(email: 'test3@example.com', password: 'password123')

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
      owner = User.register(email: 'test2@example.com', password: 'password123')
      listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99,
                               owner_id: owner.id, start_date: '2021-05-27', end_date: '2021-05-28')
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

  describe '::find_by_id' do
    it 'finds a booking object' do
      owner = User.register(email: 'test2@example.com', password: 'password123')
      listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99,
                               owner_id: owner.id, start_date: '2021-05-27', end_date: '2021-05-28')
      user = User.register(email: 'test@example.com', password: 'password123')

      booking = Booking.create(start_date: '2021-07-12', listing_id: listing.id, user_id: user.id)

      booking_id = Booking.find_by_id(id: booking.id)

      expect(booking_id.start_date).to eq('2021-07-12')
      expect(booking_id.listing_id).to eq(listing.id)
      expect(booking_id.user_id).to eq(user.id)
      expect(booking_id.confirmed).to be_nil
    end
  end

  describe '#accept' do
    it 'allows a booking to be accepted' do
      owner = User.register(email: 'test2@example.com', password: 'password123')
      listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99,
                               owner_id: owner.id, start_date: '2021-05-27', end_date: '2021-05-28')
      user = User.register(email: 'test@example.com', password: 'password123')

      booking = Booking.create(start_date: '2021-07-12', listing_id: listing.id, user_id: user.id)
      booking2 = Booking.create(start_date: '2021-08-12', listing_id: listing.id, user_id: user.id)
      booking.accept

      expect(booking.confirmed).to eq true
      expect(booking2.confirmed).to eq nil
    end
  end

  describe '#reject' do
    it 'allows a booking to be rejected' do
      owner = User.register(email: 'test2@example.com', password: 'password123')
      listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99,
                               owner_id: owner.id, start_date: '2021-05-27', end_date: '2021-05-28')
      user = User.register(email: 'test@example.com', password: 'password123')

      booking = Booking.create(start_date: '2021-07-12', listing_id: listing.id, user_id: user.id)
      booking2 = Booking.create(start_date: '2021-08-12', listing_id: listing.id, user_id: user.id)
      booking.reject

      expect(booking.confirmed).to eq false
      expect(booking2.confirmed).to eq nil
    end
  end

  describe '::incoming_bookings' do
    context 'given an owner id' do
      it 'returns all bookings where the listing is owned by the user with this id' do
        owner = User.register(email: 'test2@example.com', password: 'password123')
        other_owner = User.register(email: 'test3@example.com', password: 'password123')
        listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99,
                                 owner_id: owner.id, start_date: '2021-05-27', end_date: '2021-05-28')
        other_listing = Listing.create(name: 'test name 2', description: 'test description 2', price: 99.99,
                                       owner_id: other_owner.id, start_date: '2021-05-27', end_date: '2021-05-28')
        user = User.register(email: 'test@example.com', password: 'password123')
        booking = Booking.create(start_date: '2021-07-12', listing_id: listing.id, user_id: user.id)
        Booking.create(start_date: '2021-08-12', listing_id: listing.id, user_id: user.id)
        Booking.create(start_date: '2021-09-12', listing_id: other_listing.id, user_id: user.id)

        incoming_bookings = Booking.incoming_bookings(owner_id: owner.id)

        expect(incoming_bookings.length).to eq(2)
        expect(incoming_bookings.first.id).to eq(booking.id)
        expect(incoming_bookings.first.confirmed).to be_nil
        expect(incoming_bookings.first.start_date).to eq('2021-07-12')
      end
    end
  end

  describe '::exists' do
    it 'returns true if a confirmed booking exists for a given date and listing' do
      owner = User.register(email: 'test2@example.com', password: 'password123')
      user = User.register(email: 'test3@example.com', password: 'password123')
      listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99,
                               owner_id: owner.id, start_date: '2021-05-27', end_date: '2021-05-28')
      booking = Booking.create(start_date: '2021-07-12', listing_id: listing.id, user_id: user.id)

      booking.accept

      existing_booking = Booking.exists(start_date: booking.start_date, listing_id: listing.id)

      expect(existing_booking).to eq(true)
    end

    it ' returns false if booking doesnt exists for given date and listing' do
      owner = User.register(email: 'test2@example.com', password: 'password123')
      user = User.register(email: 'test3@example.com', password: 'password123')
      listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99,
                               owner_id: owner.id, start_date: '2021-05-27', end_date: '2021-05-28')
      booking = Booking.create(start_date: '2021-07-12', listing_id: listing.id, user_id: user.id)

      existing_booking = Booking.exists(start_date: '2022-07-12', listing_id: listing.id)

      expect(existing_booking).to eq(false)
    end
  end

  describe '::reject_all' do
    it 'rejects all bookings except 1 for a listing on a given day' do
      owner = User.register(email: 'test2@example.com', password: 'password123')
      user = User.register(email: 'test3@example.com', password: 'password123')
      user_two = User.register(email: 'test4@example.com', password: 'password123')
      listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99,
                               owner_id: owner.id, start_date: '2021-05-27', end_date: '2021-05-28')
      booking = Booking.create(start_date: '2021-07-12', listing_id: listing.id, user_id: user.id)
      booking_two = Booking.create(start_date: '2021-07-12', listing_id: listing.id, user_id: user_two.id)

      Booking.reject_all(listing_id: listing.id, start_date: booking.start_date, id: booking.id)
      booking_two_copy = Booking.find_by_id(id: booking_two.id)
      expect(booking.confirmed).to eq(nil)
      expect(booking_two_copy.confirmed).to eq('f')
    end
  end
end
