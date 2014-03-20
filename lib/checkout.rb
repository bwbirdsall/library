class Checkout

  attr_reader :due_date, :copy_id, :patron_id, :returned, :id

  def initialize(due_date, copy_id, patron_id, returned = false, id = nil)
    @due_date = due_date
    @copy_id = copy_id
    @patron_id = patron_id
    @returned = returned
    @id = id
  end

  def save
    @id = DB.exec("INSERT INTO checkouts (copies_id, patron_id, due_date, returned) VALUES (#{@copy_id}, #{@patron_id}, '#{@due_date}', #{@returned}) RETURNING id;").first['id'].to_i
  end

  def self.all
    checkouts =[]
    results = DB.exec("SELECT * FROM checkouts;")
     results.each do |result|
      id = result['id'].to_i
      due_date = result['due_date']
      patron_id = result['patron_id'].to_i
      returned = result['returned'] == 't'
      copy_id = result['copies_id'].to_i
      checkouts << Checkout.new(due_date, copy_id, patron_id, returned, id)
    end
    checkouts
  end

  def ==(another_checkout)
    @due_date == another_checkout.due_date
    @copy_id == another_checkout.copy_id
    @patron_id == another_checkout.patron_id
    @returned == another_checkout.returned
    @id == another_checkout.id
  end

  def check_in
    @returned = true
    DB.exec("UPDATE checkouts SET returned = 't' WHERE id = #{@id}")
  end

  def self.availible_quantity(title)
    copies = Book.copy_count(title)
    checkedout_copies = DB.exec("SELECT COUNT (checkouts.id) FROM checkouts JOIN copies ON checkouts.copies_id = copies.id JOIN books ON copies.book_id = books.id WHERE books.title = '#{title}' AND checkouts.returned = false;").first['count'].to_i
    copies - checkedout_copies
  end

  def self.overdue
    results = DB.exec("SELECT * FROM checkouts WHERE due_date < NOW() AND returned = 'f';")
    overdue_books =[]
    results.each do |result|
       returned = result['returned'] == 't'
        overdue_books << Checkout.new(result['due_date'], result['copies_id'].to_i, result['patron_id'].to_i, returned, result['id'].to_i)
      end
    overdue_books
  end
end
