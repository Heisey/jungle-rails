require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do

    context 'Happy Endings for users' do
      it 'is valid if created with a first_name, last_name, email, password, and password_confirmation' do
        user = User.new(:first_name => "Archie", :last_name => "Puppy", :email => "archieg@email.com", :password => "testing", :password_confirmation => "testing")
        expect(user).to be_valid
      end
    end

    context 'Very unhappy wife for users' do
      it 'is invalid if created without a last_name' do
        user = User.new(:first_name => "Archie", :last_name => nil, :email => "archie@email.com", :password => "testing", :password_confirmation => "testing")
        expect(user).to_not be_valid
      end

      it 'is invalid if created without a first_name' do
        user = User.new(:first_name => nil, :last_name => "Puppy", :email => "archie@email.com", :password => "testing", :password_confirmation => "testing")
        expect(user).to_not be_valid
      end
      
      it 'is invalid if created without an email' do
        user1 = User.new(:first_name => "Archie", :last_name => "Puppy", :email => nil, :password => "testing", :password_confirmation => "testing")
        expect(user1).to_not be_valid
      end

      it 'is invalid if created without a password' do
        user = User.new(:first_name => "Archie", :last_name => "Puppy", :email => "testing@email.com", :password => nil, :password_confirmation => "testing")
        expect(user).to_not be_valid
      end

      it 'is invalid if created without a password_confirmation' do
        user = User.new(:first_name => "Archie", :last_name => "Puppy", :email => "archie@email.com", :password => "testing", :password_confirmation => nil)
        expect(user).to_not be_valid
      end

      it 'is invalid if created with a password with length less than 6' do
        user = User.new(:first_name => "Archie", :last_name => "Puppy", :email => "archie@email.com", :password => "test", :password_confirmation => "testing")
        expect(user).to_not be_valid
      end

      it "is invalid if password and password_confirmation don't match" do
        user = User.new(:first_name => "Archie", :last_name => "Puppy", :email => "archie@email.com", :password => "testing", :password_confirmation => "doesn't match")
        expect(user).to_not be_valid
      end

      context 'testing email uniqueness' do
        before do
          user = User.create(:first_name => "Archie", :last_name => "Puppy", :email => "archie@email.com", :password => "testing", :password_confirmation => "testing")
        end

        it "is invalid if created without a unique email" do
          user2 = User.new(:first_name => "Archie", :last_name => "Puppy", :email => "archie@email.com", :password => "testing", :password_confirmation => "testing")
          expect(user2).to_not be_valid
        end

        it "is invalid if created without a unique email that is case-sensitive" do
          user1 = User.new(:first_name => "Archie", :last_name => "Puppy", :email => "ARCHIE@email.com", :password => "testing", :password_confirmation => "testing")
          expect(user1).to_not be_valid
        end
      end

    end
  end

  describe '.authenticate_with_credentials' do
    before do
      user = User.create(:first_name => "Archie", :last_name => "Puppy", :email => "archie@email.com", :password => "testing", :password_confirmation => "testing")
    end

    context 'Fake ID works' do
      it 'is returns the user object when the username and password are correct' do
        user = User.authenticate_with_credentials("archie@email.com", "testing")
        expect(user).to_not be_nil
      end

      it 'is returns the user object when the username and password are correct but username is entered with leading and trailing spaces' do
        user = User.authenticate_with_credentials("   archie@email.com   ", "testing")
        expect(user).to_not be_nil
      end

      it 'is returns the user object when the username and password are correct and username is not case sensitive' do
        user = User.authenticate_with_credentials("ArChIe@Email.COm", "testing")
        expect(user).to_not be_nil
      end
    end

    context 'Caught with A suitcase of fake passports with no etradition' do
      it 'returns nil if the user email is not in the database' do
        user = User.authenticate_with_credentials("Santas@email.com", "testing")
        expect(user).to be_nil
      end

      it 'returns nil if the user password does not authenticate with the user.authenticate method' do
        user = User.authenticate_with_credentials("testing@email.com", "badPuppy")
        expect(user).to be_nil
      end
    end

  end
end
