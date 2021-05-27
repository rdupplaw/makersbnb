# frozen_string_literal: true

class Booking
  attr_reader :id, :confirmed, :start_date, :listing_id, :user_id

  def initialize(id:, confirmed:, start_date:, listing_id:, user_id:)
    @id = id
    @confirmed = confirmed
    @start_date = start_date
    @listing_id = listing_id
    @user_id = user_id
  end

  def self.create(start_date:, listing_id:, user_id:)
    booking = DatabaseConnection.query_params('INSERT INTO bookings (start_date, confirmed, listing_id, user_id) VALUES ($1, $2, $3, $4) RETURNING id, start_date, listing_id, user_id;',
                                              [start_date, nil, listing_id, user_id]).first
    Booking.new(id: booking['id'], confirmed: nil, start_date: booking['start_date'], listing_id: booking['listing_id'],
                user_id: booking['user_id'])
  end

  def self.where(user_id:)
    results = DatabaseConnection.query_params('SELECT * FROM bookings WHERE user_id=$1', [user_id])
    results.map do |booking|
      Booking.new(id: booking['id'], confirmed: booking['confirmed'], start_date: booking['start_date'], listing_id: booking['listing_id'],
                  user_id: booking['user_id'])
    end
  end

  def self.find_by_id(id:)
    result = DatabaseConnection.query("SELECT * FROM bookings WHERE id=#{id}")
    Booking.new(id: result[0]['id'], confirmed: result[0]['confirmed'], start_date: result[0]['start_date'],
                listing_id: result[0]['listing_id'], user_id: result[0]['user_id'])
  end

  def accept
    DatabaseConnection.query("UPDATE bookings SET confirmed = TRUE WHERE id = #{id}")
    confirm_booking
  end

  def reject
    DatabaseConnection.query("UPDATE bookings SET confirmed = FALSE WHERE id = #{id}")
    reject_booking
  end

  def self.incoming_bookings(owner_id:)
    results = DatabaseConnection.query_params(
      'SELECT * FROM bookings WHERE listing_id IN (SELECT id FROM listings WHERE owner_id=$1);',
      [owner_id]
    )
    results.map do |booking|
      Booking.new(id: booking['id'], confirmed: booking['confirmed'], start_date: booking['start_date'], listing_id: booking['listing_id'],
                  user_id: booking['user_id'])
    end
  end

  def self.exists(start_date:, listing_id:)
    dbname = ENV['RACK_ENV'] == 'test' ? 'makersbnb_test' : 'makersbnb'
    connection = PG.connect(dbname: dbname)
    result = connection.exec_params('SELECT * FROM bookings WHERE confirmed=true AND start_date=$1 AND listing_id=$2',
                                    [start_date, listing_id]).first
    result ? true : false
  end

  private

  def confirm_booking
    @confirmed = true
  end

  def reject_booking
    @confirmed = false
  end
end
