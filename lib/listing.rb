# frozen_string_literal: true

require 'pg'

# ORM for listings table
class Listing
  attr_reader :id, :name, :description, :price, :owner_id, :start_date, :end_date

  def initialize(id:, name:, description:, price:, owner_id:, start_date:, end_date:)
    @id = id
    @name = name
    @description = description
    @price = price
    @owner_id = owner_id
    @start_date = start_date
    @end_date = end_date
  end

  def self.all
    result = DatabaseConnection.query('SELECT * FROM listings')
    result.map do |listing|
      Listing.new(id: listing['id'], name: listing['name'], description: listing['description'],
                  price: listing['price'], owner_id: listing['owner_id'], start_date: listing['start_date'], end_date: listing['end_date'])
    end
  end

  def self.create(name:, description:, price:, owner_id:, start_date:, end_date:)
    listing = DatabaseConnection.query_params('INSERT INTO listings (name, description, price, owner_id, start_date, end_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id, name, description, price, owner_id, start_date, end_date;',
                                              [name, description, price, owner_id, start_date, end_date]).first
    Listing.new(id: listing['id'], name: listing['name'], description: listing['description'],
                price: listing['price'], owner_id: listing['owner_id'], start_date: listing['start_date'], end_date: listing['end_date'])
  end

  def self.find(id:)
    result = DatabaseConnection.query("SELECT * FROM listings WHERE id = #{id};")
    Listing.new(
      id: result[0]['id'],
      name: result[0]['name'],
      description: result[0]['description'],
      price: result[0]['price'],
      owner_id: result[0]['owner_id'],
      start_date: result[0]['start_date'],
      end_date: result[0]['end_date']
    )
  end
end
