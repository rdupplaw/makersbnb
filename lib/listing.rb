require 'pg'

class Listing
  attr_reader :id, :name, :description, :price

  def initialize(id:, name:, description:, price:)
    @id = id
    @name = name
    @description = description
    @price = price
  end

  def self.all
    dbname = ENV['RACK_ENV'] == 'test' ? 'makersbnb_test' : 'makersbnb'
    connection = PG.connect(dbname: dbname)
    result = connection
             .exec_params('SELECT * FROM listings')
    result.map do |result|
      Listing.new(id: result['id'], name: result['name'], description: result['description'], price: result['price'])
    end
  end

  def self.create(name:, description:, price:)
    dbname = ENV['RACK_ENV'] == 'test' ? 'makersbnb_test' : 'makersbnb'
    connection = PG.connect(dbname: dbname)
    result = connection
             .exec_params('INSERT INTO listings (name, description, price) VALUES ($1, $2, $3) RETURNING id, name, description, price;',
                          [name, description, price]).first
    Listing.new(id: result['id'], name: result['name'], description: result['description'], price: result['price'])
  end
end
