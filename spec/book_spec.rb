require 'spec_helper'


describe Book do
  describe 'initialize' do
    it 'should initialize an instance of Book' do
      b = Book.new("b")
      b.should be_an_instance_of Book
    end

    it 'should know its title' do
      b = Book.new("Of Mice and Men")
      b.title.should eq "Of Mice and Men"
    end
  end

  describe 'save' do
    it 'should save the book to the database' do
      b = Book.new("Of Mice and Men")
      Book.all.should eq []
      b.save
      Book.all.should eq [b]
    end

    it 'should not save duplicate copies' do
      b = Book.new("Of Mice and Men")
      b.save
      b1 = Book.new("Of Mice and Men")
      b1.save
      Book.all.length.should eq 1
      Book.copy_count("Of Mice and Men").should eq 2
    end
  end

  describe 'Book.all' do
    it 'should return all of the book data as book objects' do
      b = Book.new("Of Mice and Men")
      b.save
      Book.all.should eq [b]
    end
  end


  describe 'update' do
    it 'can be updated with a new or corrected title' do
      b = Book.new("Of Mice and Men")
      b.update("The DaVinci Code")
      b.title.should eq "The DaVinci Code"
    end
  end

  describe 'Book.search' do
    it 'should be able to search books by title and return the title' do
       b = Book.new("A Confederacy of Dunces")
       b.save
       Book.search("A Confederacy of Dunces").should eq b.id
     end
   end

  describe 'Book.authorship' do
    it 'assigns an author to a book' do
       b = Book.new("A Confederacy of Dunces")
       b.save
       a = Author.new("John Kennedy OToole")
       a.save
       Book.authorship('A Confederacy of Dunces', "John Kennedy OToole")
       Book.find_authors('A Confederacy of Dunces').should eq [a]
      end
    end

  describe 'copy_check?' do
    it 'should check if the book is already in the library' do
      b1 = Book.new("A Confederacy of Dunces")
      b1.copy_check?.should eq false

    end
  end

  describe 'copy_check?' do
    it 'should check if the book is already in the library' do
      b1 = Book.new("A Confederacy of Dunces")
      b1.save
      b2 = Book.new("A Confederacy of Dunces")
      b2.copy_check?.should eq true
    end
  end

  describe 'copy' do
    it 'should make a copy if the title is already in the library' do
      b1 = Book.new("A Confederacy of Dunces")
      b1.save
      b2 = Book.new("A Confederacy of Dunces")
      b2.copy_check?.should eq true
    end
  end

  describe 'Book.copy_count' do
    it 'should make a copy if the title is already in the library' do
      b1 = Book.new("A Confederacy of Dunces")
      b1.save
      b1.copy
      Book.copy_count("A Confederacy of Dunces").should eq 2
    end
  end

  describe 'Book.availible_copies' do
    it 'should return a copies id of a given title' do
      b1 = Book.new("A Confederacy of Dunces")
      copy_id1 = b1.save
      copy_id2 = b1.copy
      Book.availible_copies("A Confederacy of Dunces").should eq copy_id1 || copy_id2
    end
  end
end
