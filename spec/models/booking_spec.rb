# frozen_string_literal: true

require 'booking'
require 'listing'
require 'user'

describe Booking do
  let(:mock_user) { (PG.connect(dbname: 'makersbnb_test')).exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email3', 'encrypted_password3']).first }
  let(:mock_user_2) { (PG.connect(dbname: 'makersbnb_test')).exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email2', 'encrypted_password2']).first }
  let(:mock_owner) { (PG.connect(dbname: 'makersbnb_test')).exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email4', 'encrypted_password4']).first }
  let(:mock_owner_2) { (PG.connect(dbname: 'makersbnb_test')).exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email5', 'encrypted_password5']).first }
  let(:mock_listing) { (PG.connect(dbname: 'makersbnb_test')).exec('INSERT INTO listings (name, description, price, owner_id, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;',
  ['name', 'description', 99.99, mock_owner['id'], '2021-12-12', '2021-12-13']).first }
  let(:mock_listing_2) { (PG.connect(dbname: 'makersbnb_test')).exec('INSERT INTO listings (name, description, price, owner_id, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;',
  ['name', 'description', 99.99, mock_owner_2['id'], '2021-12-12', '2021-12-13']).first }


  describe '::where' do
    it 'returns all bookings for a specified user id' do
      booking1 = Booking.create(start_date: '2021-07-12', listing_id: mock_listing['id'], user_id: mock_user['id'])
      booking2 = Booking.create(start_date: '2021-08-12', listing_id: mock_listing['id'], user_id: mock_user_2['id'])
      booking3 = Booking.create(start_date: '2021-09-12', listing_id: mock_listing['id'], user_id: mock_user['id'])

      bookings = Booking.where(user_id: mock_user['id'])
      
      expect(bookings.length).to eq(2)
      expect(bookings.first).to be_a(Booking)
      expect(bookings.first.id).to eq(booking1.id)
      expect(bookings.first.start_date).to eq('2021-07-12')
      expect(bookings.first.listing_id).to eq(mock_listing['id'])
      expect(bookings.first.user_id).to eq(mock_user['id'])
    end
  end

  describe '::create' do
    it 'creates a new Booking object' do
      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing['id'], user_id: mock_user['id'])
      persisted_data = PG.connect(dbname: 'makersbnb_test').exec_params('SELECT * FROM bookings WHERE id=$1',
                                                                        [booking.id])

      expect(booking.id).to eq(persisted_data[0]['id'])
      expect(booking.start_date).to eq('2021-07-12')
      expect(booking.listing_id).to eq(mock_listing['id'])
      expect(booking.user_id).to eq(mock_user['id'])
      expect(booking.confirmed).to be_nil
    end
  end

  describe '::find_by_id' do
    it 'finds a booking object' do
      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing['id'], user_id: mock_user['id'])

      booking_id = Booking.find_by_id(id: booking.id)

      expect(booking_id.start_date).to eq('2021-07-12')
      expect(booking_id.listing_id).to eq(mock_listing['id'])
      expect(booking_id.user_id).to eq(mock_user['id'])
      expect(booking_id.confirmed).to be_nil
    end
  end

  describe '#accept' do
    it 'allows a booking to be accepted' do
      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing['id'], user_id: mock_user['id'])
      booking2 = Booking.create(start_date: '2021-08-12', listing_id: mock_listing['id'], user_id: mock_user['id'])
      booking.accept

      expect(booking.confirmed).to eq true
      expect(booking2.confirmed).to eq nil
    end
  end

  describe '#reject' do
    it 'allows a booking to be rejected' do
      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing['id'], user_id: mock_user['id'])
      booking2 = Booking.create(start_date: '2021-08-12', listing_id: mock_listing['id'], user_id: mock_user['id'])
      booking.reject

      expect(booking.confirmed).to eq false
      expect(booking2.confirmed).to eq nil
    end
  end

  describe '::incoming_bookings' do
    context 'given an owner id' do
      it 'returns all bookings where the listing is owned by the user with this id' do
        booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing['id'], user_id: mock_user['id'])
        Booking.create(start_date: '2021-08-12', listing_id: mock_listing['id'], user_id: mock_user['id'])
        Booking.create(start_date: '2021-09-12', listing_id: mock_listing_2['id'], user_id: mock_user['id'])

        incoming_bookings = Booking.incoming_bookings(owner_id: mock_owner['id'])

        expect(incoming_bookings.length).to eq(2)
        expect(incoming_bookings.first.id).to eq(booking.id)
        expect(incoming_bookings.first.confirmed).to be_nil
        expect(incoming_bookings.first.start_date).to eq('2021-07-12')
      end
    end
  end

  describe '::exists' do
    it 'returns true if a confirmed booking exists for a given date and listing' do
      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing['id'], user_id: mock_user['id'])
      booking.accept
      existing_booking = Booking.exists(start_date: booking.start_date, listing_id: mock_listing['id'])

      expect(existing_booking).to eq(true)
    end

    it ' returns false if booking doesnt exists for given date and listing' do
      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing['id'], user_id: mock_user['id'])
      existing_booking = Booking.exists(start_date: '2022-07-12', listing_id: mock_listing['id'])

      expect(existing_booking).to eq(false)
    end
  end

  describe '::reject_all' do
    it 'rejects all bookings except 1 for a listing on a given day' do
      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing['id'], user_id: mock_user['id'])
      booking_two = Booking.create(start_date: '2021-07-12', listing_id: mock_listing['id'], user_id: mock_user_2['id'])

      Booking.reject_all(listing_id: mock_listing['id'], start_date: booking.start_date, id: booking.id)
      booking_two_copy = Booking.find_by_id(id: booking_two.id)
      expect(booking.confirmed).to eq(nil)
      expect(booking_two_copy.confirmed).to eq('f')
    end
  end
end
