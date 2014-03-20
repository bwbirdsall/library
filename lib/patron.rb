class Patron

  attr_reader :name, :id

  def initialize(name, id = nil)
    @name = name
    @id = id
  end

  def save
    @id = DB.exec("INSERT INTO patrons (name) VALUES ('#{@name}') RETURNING id;").first['id'].to_i
  end

  def self.search(search)
    DB.exec("SELECT id FROM patron WHERE name = '#{search}';").first['id'].to_i
  end


  def self.all
    patrons =[]
    results = DB.exec("SELECT * FROM patrons;")
    results.each do |result|
      name = result['name']
      id = result['id'].to_i
      patrons << Patron.new(name, id)
    end
    patrons
  end

  def ==(another_patron)
    @name == another_patron.name && @id == another_patron.id
  end

  def update(new_name)
    @name = new_name
  end

  def borrower_history
    results = DB.exec("SELECT * FROM checkouts WHERE patron_id = #{@id};")
    checkouts =[]
    results.each do |result|
       returned = result['returned'] == 't'
      checkouts << Checkout.new(result['due_date'], result['copies_id'].to_i, result['patron_id'].to_i, returned, result['id'].to_i)
    end
  checkouts
  end

  def outstanding_checkouts
    results = DB.exec("SELECT * FROM checkouts WHERE patron_id = #{@id} AND returned = 'f';")
    current_checkouts =[]
    results.each do |result|
       returned = result['returned'] == 't'
      current_checkouts << Checkout.new(result['due_date'], result['copies_id'].to_i, result['patron_id'].to_i, returned, result['id'].to_i)
      end
    current_checkouts
  end

  def when_due(title)
    DB.exec("SELECT c.due_date FROM checkouts c JOIN copies a ON c.copies_id = a.id JOIN books b ON b.id = a.book_id WHERE b.title = '#{title}';").first['due_date']
  end
end
