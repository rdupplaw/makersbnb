require 'listing'

describe Listing do
  describe '::all' do
    it 'returns an array of Listing objects' do
      listing = Listing.create(name: 'test name 1', description: 'test description 1', price: 89.99)
      Listing.create(name: 'test name 2', description: 'test description 2', price: 99.99)
      Listing.create(name: 'test name 3', description: 'test description 3', price: 79.99)

      result = Listing.all

      expect(result.length).to eq(3)
      expect(result.first).to be_a(Listing)
      expect(result.first.id).to eq(listing.id)
      expect(result.first.name).to eq('test name 1')
      expect(result.first.description).to eq('test description 1')
      expect(result.first.price).to eq('$89.99')
    end
  end

  describe '::create' do
    it 'creates a new listing' do
      listing = Listing.create(name: 'test name', description: 'test description', price: 99.99)

      expect(Listing.all.first.id).to eq(listing.id)
      expect(Listing.all.first.name).to eq('test name')
      expect(Listing.all.first.description).to eq('test description')
      expect(Listing.all.first.price).to eq('$99.99')
    end
  end
end
