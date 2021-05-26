# frozen_string_literal: true

require 'pg'

# Handles persistent connection to database
class DatabaseConnection
  class << self
    attr_reader :connection
  end

  def self.setup(dbname)
    @connection = PG.connect(dbname: dbname)
  end

  def self.query(sql_string)
    connection.exec(sql_string)
  end

  def self.query_params(sql_string, params)
    connection.exec_params(sql_string, params)
  end
end
