require 'rspec'
require 'pg'
require 'author'
require 'book'
require 'checkout'
require 'patron'

DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM author *;")
    DB.exec("DELETE FROM copies *;")
    DB.exec("DELETE FROM patrons *;")
    DB.exec("DELETE FROM checkouts *;")
  end
end
