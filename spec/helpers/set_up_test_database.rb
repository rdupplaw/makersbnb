# frozen_string_literal: true

require 'pg'

def wipe_table
  connection = PG.connect(dbname: 'makersbnb_test')
  connection.exec('TRUNCATE listings, users, bookings;')
end
