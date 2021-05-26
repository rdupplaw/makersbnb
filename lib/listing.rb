# frozen_string_literal: true

require 'pg'

# ORM for listings table
class Listing
  attr_reader :id, :name, :description, :price, :owner_id

  def initialize(id:, name:, description:, price:, owner_id:)
    @id = id
    @name = name
    @description = description
    @price = price
    @owner_id = owner_id
  end

  def self.all
    result = DatabaseConnection.query('SELECT * FROM listings')
    result.map do |listing|
      Listing.new(id: listing['id'], name: listing['name'], description: listing['description'],
                  price: listing['price'], owner_id: listing['owner_id'])
    end
  end

  def self.create(name:, description:, price:, owner_id:)
    listing = DatabaseConnection.query_params('INSERT INTO listings (name, description, price, owner_id) VALUES ($1, $2, $3, $4) RETURNING id, name, description, price, owner_id;',
                                              [name, description, price, owner_id]).first
    Listing.new(id: listing['id'], name: listing['name'], description: listing['description'],
                price: listing['price'], owner_id: listing['owner_id'])
  end

  def self.find(id:)
    result = DatabaseConnection.query("SELECT * FROM listings WHERE id = #{id};")
    Listing.new(
      id: result[0]['id'],
      name: result[0]['name'],
      description: result[0]['description'],
      price: result[0]['price'],
      owner_id: result[0]['owner_id']
    )
  end
end
