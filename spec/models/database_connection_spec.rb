# frozen_string_literal: true

require 'database_connection'

describe DatabaseConnection do
  let(:dbname) { 'makersbnb_test' }
  describe '::setup' do
    it 'connects to the database via PG' do
      expect(PG).to receive(:connect).with(dbname: dbname)

      DatabaseConnection.setup(dbname)
    end

    it 'the connection is persistent' do
      connection = DatabaseConnection.setup(dbname)

      expect(connection).to eq(DatabaseConnection.connection)
    end
  end

  describe '::query' do
    it 'queries the database via PG' do
      connection = DatabaseConnection.setup(dbname)
      expect(connection).to receive(:exec).with('SELECT * FROM users LIMIT 10')

      DatabaseConnection.query('SELECT * FROM users LIMIT 10')
    end
  end

  describe '::query_params' do
    it 'queries the database via PG with params' do
      connection = DatabaseConnection.setup(dbname)
      expect(connection).to receive(:exec_params).with('SELECT * FROM users LIMIT $1', [10])

      DatabaseConnection.query_params('SELECT * FROM users LIMIT $1', [10])
    end
  end
end
