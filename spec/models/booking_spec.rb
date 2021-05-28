# frozen_string_literal: true

require 'booking'
require 'listing'
require 'user'

describe Booking do
  describe '::where' do
    it 'returns all bookings for a specified user id' do
      connection = PG.connect(dbname: 'makersbnb_test')
      mock_owner_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email', 'encrypted_password']).first
      mock_user_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email3', 'encrypted_password3']).first
      mock_user_2_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email2', 'encrypted_password2']).first
      mock_listing_id = connection.exec('INSERT INTO listings (name, description, price, owner_id, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;',
                        ['name', 'description', 99.99, mock_user_id['id'], '2021-12-12', '2021-12-13']).first

      booking1 = Booking.create(start_date: '2021-07-12', listing_id: mock_listing_id['id'], user_id: mock_user_id['id'])
      booking2 = Booking.create(start_date: '2021-08-12', listing_id: mock_listing_id['id'], user_id: mock_user_2_id['id'])
      booking3 = Booking.create(start_date: '2021-09-12', listing_id: mock_listing_id['id'], user_id: mock_user_id['id'])

      bookings = Booking.where(user_id: mock_user_id['id'])
      
      expect(bookings.length).to eq(2)
      expect(bookings.first).to be_a(Booking)
      expect(bookings.first.id).to eq(booking1.id)
      expect(bookings.first.start_date).to eq('2021-07-12')
      expect(bookings.first.listing_id).to eq(mock_listing_id['id'])
      expect(bookings.first.user_id).to eq(mock_user_id['id'])
    end
  end

  describe '::create' do
    it 'creates a new Booking object' do
      connection = PG.connect(dbname: 'makersbnb_test')
      mock_owner_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email', 'encrypted_password']).first
      mock_user_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email2', 'encrypted_password2']).first
      mock_listing_id = connection.exec('INSERT INTO listings (name, description, price, owner_id, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;',
                        ['name', 'description', 99.99, mock_user_id['id'], '2021-12-12', '2021-12-13']).first

      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing_id['id'], user_id: mock_user_id['id'])
      persisted_data = PG.connect(dbname: 'makersbnb_test').exec_params('SELECT * FROM bookings WHERE id=$1',
                                                                        [booking.id])

      expect(booking.id).to eq(persisted_data[0]['id'])
      expect(booking.start_date).to eq('2021-07-12')
      expect(booking.listing_id).to eq(mock_listing_id['id'])
      expect(booking.user_id).to eq(mock_user_id['id'])
      expect(booking.confirmed).to be_nil
    end
  end

  describe '::find_by_id' do
    it 'finds a booking object' do
      connection = PG.connect(dbname: 'makersbnb_test')
      mock_owner_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email', 'encrypted_password']).first
      mock_user_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email2', 'encrypted_password2']).first
      mock_listing_id = connection.exec('INSERT INTO listings (name, description, price, owner_id, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;',
                        ['name', 'description', 99.99, mock_user_id['id'], '2021-12-12', '2021-12-13']).first

      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing_id['id'], user_id: mock_user_id['id'])

      booking_id = Booking.find_by_id(id: booking.id)

      expect(booking_id.start_date).to eq('2021-07-12')
      expect(booking_id.listing_id).to eq(mock_listing_id['id'])
      expect(booking_id.user_id).to eq(mock_user_id['id'])
      expect(booking_id.confirmed).to be_nil
    end
  end

  describe '#accept' do
    it 'allows a booking to be accepted' do
      connection = PG.connect(dbname: 'makersbnb_test')
      mock_owner_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email', 'encrypted_password']).first
      mock_user_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email2', 'encrypted_password2']).first
      mock_listing_id = connection.exec('INSERT INTO listings (name, description, price, owner_id, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;',
                        ['name', 'description', 99.99, mock_user_id['id'], '2021-12-12', '2021-12-13']).first

      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing_id['id'], user_id: mock_user_id['id'])
      booking2 = Booking.create(start_date: '2021-08-12', listing_id: mock_listing_id['id'], user_id: mock_user_id['id'])
      booking.accept

      expect(booking.confirmed).to eq true
      expect(booking2.confirmed).to eq nil
    end
  end

  describe '#reject' do
    it 'allows a booking to be rejected' do
      connection = PG.connect(dbname: 'makersbnb_test')
      mock_owner_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email', 'encrypted_password']).first
      mock_user_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email2', 'encrypted_password2']).first
      mock_listing_id = connection.exec('INSERT INTO listings (name, description, price, owner_id, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;',
                        ['name', 'description', 99.99, mock_owner_id['id'], '2021-12-12', '2021-12-13']).first

      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing_id['id'], user_id: mock_user_id['id'])
      booking2 = Booking.create(start_date: '2021-08-12', listing_id: mock_listing_id['id'], user_id: mock_user_id['id'])
      booking.reject

      expect(booking.confirmed).to eq false
      expect(booking2.confirmed).to eq nil
    end
  end

  describe '::incoming_bookings' do
    context 'given an owner id' do
      it 'returns all bookings where the listing is owned by the user with this id' do
        connection = PG.connect(dbname: 'makersbnb_test')
        mock_owner_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email', 'encrypted_password']).first
        mock_listing_id = connection.exec('INSERT INTO listings (name, description, price, owner_id, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;',
                          ['name', 'description', 99.99, mock_owner_id['id'], '2021-12-12', '2021-12-13']).first
        mock_owner_2_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email2', 'encrypted_password2']).first
        mock_listing_2_id = connection.exec('INSERT INTO listings (name, description, price, owner_id, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;',
                            ['name', 'description', 99.99, mock_owner_2_id['id'], '2021-12-12', '2021-12-13']).first
        mock_user_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email3', 'encrypted_password3']).first

        booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing_id['id'], user_id: mock_user_id['id'])
        Booking.create(start_date: '2021-08-12', listing_id: mock_listing_id['id'], user_id: mock_user_id['id'])
        Booking.create(start_date: '2021-09-12', listing_id: mock_listing_2_id['id'], user_id: mock_user_id['id'])

        incoming_bookings = Booking.incoming_bookings(owner_id: mock_owner_id['id'])

        expect(incoming_bookings.length).to eq(2)
        expect(incoming_bookings.first.id).to eq(booking.id)
        expect(incoming_bookings.first.confirmed).to be_nil
        expect(incoming_bookings.first.start_date).to eq('2021-07-12')
      end
    end
  end

  describe '::exists' do
    it 'returns true if a confirmed booking exists for a given date and listing' do
      connection = PG.connect(dbname: 'makersbnb_test')
      mock_owner_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email', 'encrypted_password']).first
      mock_user_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email2', 'encrypted_password2']).first
      mock_listing_id = connection.exec('INSERT INTO listings (name, description, price, owner_id, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;',
                        ['name', 'description', 99.99, mock_owner_id['id'], '2021-12-12', '2021-12-13']).first

      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing_id['id'], user_id: mock_user_id['id'])

      booking.accept

      existing_booking = Booking.exists(start_date: booking.start_date, listing_id: mock_listing_id['id'])

      expect(existing_booking).to eq(true)
    end

    it ' returns false if booking doesnt exists for given date and listing' do
      connection = PG.connect(dbname: 'makersbnb_test')
      mock_owner_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email', 'encrypted_password']).first
      mock_user_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email2', 'encrypted_password2']).first
      mock_listing_id = connection.exec('INSERT INTO listings (name, description, price, owner_id, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;',
                        ['name', 'description', 99.99, mock_owner_id['id'], '2021-12-12', '2021-12-13']).first

      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing_id['id'], user_id: mock_user_id['id'])

      existing_booking = Booking.exists(start_date: '2022-07-12', listing_id: mock_listing_id['id'])

      expect(existing_booking).to eq(false)
    end
  end

  describe '::reject_all' do
    it 'rejects all bookings except 1 for a listing on a given day' do
      connection = PG.connect(dbname: 'makersbnb_test')
      mock_owner_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email', 'encrypted_password']).first
      mock_user_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email2', 'encrypted_password2']).first
      mock_user_2_id = connection.exec("INSERT INTO users (email, password) VALUES($1, $2) RETURNING id", ['email3', 'encrypted_password3']).first
      mock_listing_id = connection.exec('INSERT INTO listings (name, description, price, owner_id, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;',
                        ['name', 'description', 99.99, mock_owner_id['id'], '2021-12-12', '2021-12-13']).first

      booking = Booking.create(start_date: '2021-07-12', listing_id: mock_listing_id['id'], user_id: mock_user_id['id'])
      booking_two = Booking.create(start_date: '2021-07-12', listing_id: mock_listing_id['id'], user_id: mock_user_2_id['id'])

      Booking.reject_all(listing_id: mock_listing_id['id'], start_date: booking.start_date, id: booking.id)
      booking_two_copy = Booking.find_by_id(id: booking_two.id)
      expect(booking.confirmed).to eq(nil)
      expect(booking_two_copy.confirmed).to eq('f')
    end
  end
end
