class Book

  attr_reader :title, :id

  def initialize(title, id=nil)
    @title = title
    @id = id

  end

  def save
    if !copy_check?
      @id = DB.exec("INSERT INTO books (title) VALUES ('#{@title}') RETURNING id;").first['id'].to_i
    end
    @id = Book.search(@title)
    copy
  end

  def self.all
    books =[]
    results = DB.exec("SELECT * FROM books;")
    results.each do |result|
      title = result['title']
      id = result['id'].to_i
      books << Book.new(title, id)
    end
  books
  end

  def ==(another_book)
    @title == another_book.title
    @id == another_book.id
  end

  def delete
    DB.exec("DELETE FROM books WHERE id = #{self.id};")
    DB.exec("DELETE FROM authorships JOIN books ON authorships.book_id = books.id WHERE books.id = #{self.id};")
    DB.exec("DELETE FROM checkouts JOIN copies ON copies.id = checkouts.copies_id JOIN books ON books.id = copies.book_id WHERE book.id = #{self.id};")
    DB.exec("DELETE FROM copies JOIN books ON books.id = copies.book_id WHERE books.id = #{self.id};")
  end

  def update(new_title)
    @title = new_title
  end

  def self.search(search)
    DB.exec("SELECT id FROM books WHERE title = '#{search}';").first['id'].to_i
  end

  def self.authorship(book_title, *author_names)
    book_id = Book.search(book_title)
    author_names.each do |author_name|
      author_id = Author.search(author_name)
      DB.exec("INSERT INTO authorship (author_id, book_id) VALUES (#{author_id}, #{book_id});")
    end
  end

  def self.find_authors(book_title)
    book_id = Book.search(book_title)
    authors = []
    results = DB.exec("SELECT authorship.author_id, author.name FROM authorship JOIN author ON authorship.author_id = author.id WHERE book_id = #{book_id};")
    results.each do |result|
      authors << Author.new(result['name'], result['author_id'].to_i)
    end
    authors
  end

  def copy_check?
     DB.exec("SELECT title FROM books WHERE title = '#{@title}'").first != nil
  end

  def copy
    DB.exec("INSERT INTO copies (book_id) VALUES (#{@id}) RETURNING id;").first['id'].to_i
  end


  def self.copy_count(title)
    book_id = Book.search(title)
    DB.exec("SELECT COUNT(id) FROM copies WHERE book_id = #{book_id}").first['count'].to_i
  end

  def self.availible_copies(title)
    DB.exec("SELECT copies.id FROM copies JOIN books ON copies.book_id = books.id WHERE books.title = '#{title}';").first['id'].to_i
  end


end
