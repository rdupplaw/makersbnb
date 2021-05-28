# frozen_string_literal: true

require 'listing'

describe Listing do
  describe '::all' do
    it 'returns an array of Listing objects' do
      DatabaseConnection.connection
      user = User.register(email: 'test@example.com', password: 'password')
      listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99, owner_id: user.id,
                               start_date: '2021-05-27', end_date: '2021-05-28')
      Listing.create(name: 'test name 2', description: 'test description 2', price: 99.99, owner_id: user.id,
                     start_date: '2021-05-27', end_date: '2021-05-28')
      Listing.create(name: 'test name 3', description: 'test description 3', price: 79.99, owner_id: user.id,
                     start_date: '2021-05-27', end_date: '2021-05-28')

      result = Listing.all

      expect(result.length).to eq(3)
      expect(result.first).to be_a(Listing)
      expect(result.first.id).to eq(listing.id)
      expect(result.first.name).to eq('test name 1')
      expect(result.first.description).to eq('test description 1')
      expect(result.first.price).to eq('$89.99')
      expect(result.first.owner_id).to eq(user.id)
    end
  end

  describe '::create' do
    it 'creates a new listing' do
      user = User.register(email: 'test@example.com', password: 'password')
      listing = Listing.create(name: 'test name', description: 'test description', price: 99.99, owner_id: user.id,
                               start_date: '2021-05-27', end_date: '2021-05-28')

      expect(Listing.all.first.id).to eq(listing.id)
      expect(Listing.all.first.name).to eq('test name')
      expect(Listing.all.first.description).to eq('test description')
      expect(Listing.all.first.price).to eq('$99.99')
      expect(Listing.all.first.owner_id).to eq(user.id)
      expect(Listing.all.first.start_date).to eq(listing.start_date)
      expect(Listing.all.first.end_date).to eq(listing.end_date)
    end
  end
end
