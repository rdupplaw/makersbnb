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
    dbname = ENV['RACK_ENV'] == 'test' ? 'makersbnb_test' : 'makersbnb'
    connection = PG.connect(dbname: dbname)
    booking = connection
              .exec_params('INSERT INTO bookings (start_date, confirmed, listing_id, user_id) VALUES ($1, $2, $3, $4) RETURNING id, start_date, listing_id, user_id;',
                           [start_date, nil, listing_id, user_id]).first
    Booking.new(id: booking['id'], confirmed: nil, start_date: booking['start_date'], listing_id: booking['listing_id'],
                user_id: booking['user_id'])
  end

  def self.where(user_id:)
    dbname = ENV['RACK_ENV'] == 'test' ? 'makersbnb_test' : 'makersbnb'
    connection = PG.connect(dbname: dbname)
    results = connection
              .exec_params('SELECT * FROM bookings WHERE user_id=$1', [user_id])
    results.map do |booking|
      Booking.new(id: booking['id'], confirmed: booking['confirmed'], start_date: booking['start_date'], listing_id: booking['listing_id'],
                  user_id: booking['user_id'])
    end
  end
end
