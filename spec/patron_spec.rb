require 'spec_helper'

describe Patron do
  describe 'initialize' do
    it 'should initialize an instance of Patron' do
      p = Patron.new("JB")
      p.should be_an_instance_of Patron
    end

    it 'should know his or her name' do
      p = Patron.new("Joe Biden")
      p.name.should eq "Joe Biden"
    end
  end

  describe 'save' do
    it 'should save the patron to the database' do
      p = Patron.new("Joe Biden")
      Patron.all.should eq []
      p.save
      Patron.all.should eq [p]
    end
  end

  describe 'Patron.all' do
    it 'should return all of the patron data as patron objects' do
      p = Patron.new("Joe Biden")
      p.save
      Patron.all.should eq [p]
    end
  end

  describe 'update' do
    it 'can be updated with a new or corrected name' do
      b = Patron.new("Joe Biden")
      b.update("Joseph Biden")
      b.name.should eq "Joseph Biden"
    end
  end

  describe 'borrower_history' do
    it 'should return all of the checkouts' do
      p = Patron.new("Joe Biden")
      p.save
      b1 = Book.new("A Confederacy of Dunces")
      copyid = b1.save
      c = Checkout.new("01-01-2017", copyid, p.id)
      c.save
      p.borrower_history.should eq [c]

    end
  end

  describe 'outstanding_checkouts' do
    it 'should return all of the non-returned checkouts' do
      p = Patron.new("Joe Biden")
      p.save
      b1 = Book.new("A Confederacy of Dunces")
      copyid = b1.save
      c = Checkout.new("01-01-2017", copyid, p.id)
      c.save
      b2 = Book.new("Corvettes 1982-1987 Repair Manual")
      copyid2 = b2.save
      c2 = Checkout.new("01-01-2017", copyid2, p.id)
      c2.save
      p.borrower_history.should eq [c, c2]
      c2.check_in
      p.outstanding_checkouts.should eq [c]
    end
  end

  describe 'when_due' do
    it 'returns when a checked out book is due' do
      p = Patron.new("Joe Biden")
      p.save
      b1 = Book.new("A Confederacy of Dunces")
      copyid = b1.save
      c = Checkout.new("01-01-2017", copyid, p.id)
      c.save
      b2 = Book.new("Corvettes 1982-1987 Repair Manual")
      copyid2 = b2.save
      c2 = Checkout.new("01-25-2017", copyid2, p.id)
      c2.save
      p.when_due("Corvettes 1982-1987 Repair Manual").should eq '2017-01-25'
    end
  end


end
