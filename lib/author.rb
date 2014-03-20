class Author

  attr_reader :name, :id

  def initialize(name, id = nil)
    @name = name
    @id = id
  end

  def save
    @id = DB.exec("INSERT INTO author (name) VALUES ('#{@name}') RETURNING id;").first['id'].to_i
  end

  def self.all
    authors =[]
    results = DB.exec("SELECT * FROM author;")
    results.each do |result|
      name = result['name']
      id = result['id'].to_i
      authors << Author.new(name, id)
    end
    authors
  end

  def ==(another_author)
    @name == another_author.name
    @id == another_author.id
  end

  def self.search(search)
    DB.exec("SELECT id FROM author WHERE name = '#{search}';").first['id'].to_i
  end

  def self.books_by(author_name)
    author_id = Author.search(author_name)
    books = []
    results = DB.exec("SELECT authorship.book_id, books.title FROM authorship JOIN books ON authorship.book_id = books.id WHERE author_id = #{author_id};")
    results.each do |result|
      books << Book.new(result['title'], result['book_id'].to_i)
    end
    books
  end

end


