# frozen_string_literal: true

require 'pg'

# ORM for listings table
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
    result.map do |listing|
      Listing.new(id: listing['id'], name: listing['name'], description: listing['description'],
                  price: listing['price'])
    end
  end

  def self.create(name:, description:, price:)
    dbname = ENV['RACK_ENV'] == 'test' ? 'makersbnb_test' : 'makersbnb'
    connection = PG.connect(dbname: dbname)
    listing = connection
              .exec_params('INSERT INTO listings (name, description, price) VALUES ($1, $2, $3) RETURNING id, name, description, price;',
                           [name, description, price]).first
    Listing.new(id: listing['id'], name: listing['name'], description: listing['description'],
                price: listing['price'])
  end
end
