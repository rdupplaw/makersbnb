require 'pg'

def wipe_table
  connection = PG.connect(dbname: 'makersbnb_test')
  connection.exec('TRUNCATE listings;')
end
