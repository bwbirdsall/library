require 'spec_helper'

describe Checkout do
  describe 'initialize' do
    it 'should initialize an instance of Checkout' do
      c = Checkout.new("04-25-2845", 23, 6)
      c.should be_an_instance_of Checkout
    end

    it 'should know its due date' do
      c = Checkout.new("04-25-2845", 23, 6)
      c.due_date.should eq '04-25-2845'
    end
  end

  describe 'save' do
    it 'should save the Checkout to the database' do
      c = Checkout.new("04-25-2845", 23, 6)
      Checkout.all.should eq []
      c.save
      Checkout.all.should eq [c]
    end
  end

  describe 'Checkout.all' do
    it 'should return all of the Checkout data as Checkout objects' do
      c = Checkout.new("04-25-2845", 23, 6)
      c.save
      Checkout.all.should eq [c]
    end
  end

  describe 'check_in' do
    it 'should allow the patron to return the book' do
      c = Checkout.new("04-25-2845", 23, 6)
      c.save
      c.check_in
      c.returned.should eq true
    end
  end

  describe 'Checkout.availible_quantity' do
    it 'should return the number of availible copies of a book' do
      b1 = Book.new("A Confederacy of Dunces")
      b2 = Book.new("A Confederacy of Dunces")
      b3 = Book.new("A Confederacy of Dunces")
      copy1 = b1.save
      b2.save
      b3.save
      Checkout.availible_quantity("A Confederacy of Dunces").should eq 3
      c = Checkout.new('03/19/2014', copy1, 23)
      c.save
      Checkout.availible_quantity("A Confederacy of Dunces").should eq 2
    end
  end

  describe 'Checkout.overdue' do
    it 'should return a list of overdue checkouts' do
      p = Patron.new("Joe Biden")
      p.save
      b1 = Book.new("A Confederacy of Dunces")
      copyid = b1.save
      c = Checkout.new("01-01-1969", copyid, p.id)
      c.save
      b2 = Book.new("Corvettes 1982-1987 Repair Manual")
      copyid2 = b2.save
      c2 = Checkout.new("01-25-1981", copyid2, p.id)
      c2.save
      Checkout.overdue.should eq [c, c2]
    end
  end




 end
