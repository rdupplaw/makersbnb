# frozen_string_literal: true

require 'pg'

def wipe_table
  con = PG.connect dbname: 'makersbnb_test'
  con.exec('TRUNCATE listings, users, bookings;')
end
