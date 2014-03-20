require 'spec_helper'

describe Author do
  describe 'initialize' do
    it 'should initialize an instance of Author' do
      a = Author.new("a")
      a.should be_an_instance_of Author
    end

    it 'should know his or her name' do
      a = Author.new("Dan Brown")
      a.name.should eq "Dan Brown"
    end
  end

  describe 'save' do
    it 'should save the author to the database' do
      a = Author.new("Of Mice and Men")
      Author.all.should eq []
      a.save
      Author.all.should eq [a]
    end
  end

  describe 'Author.all' do
    it 'should return all of the author data as author objects' do
      a = Author.new("Of Mice and Men")
      a.save
      Author.all.should eq [a]
    end
  end

  describe 'Author.search' do
    it 'should return the author id of the given author' do
      a = Author.new("John Steinbeck")
      a.save
      Author.search('John Steinbeck').should eq a.id
    end
  end

  describe 'Author.books_by' do
    it 'should return the book ids by a given author' do
      a = Author.new("John Steinbeck")
      b = Book.new("The Grapes of Wrath")
      b.save
      b2 = Book.new("Of Mice and Men")
      b2.save
      a.save
      Book.authorship('The Grapes of Wrath', 'John Steinbeck')
      Book.authorship('Of Mice and Men', 'John Steinbeck')
      Author.books_by('John Steinbeck').should eq [b,b2]
    end
  end
end
