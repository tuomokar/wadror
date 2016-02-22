require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password not long enough" do
    user = User.create username:"Pekka", password:"se", password_confirmation:"se"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with password consisting only of letters" do
    user = User.create username:"Pekka", password:"Secret", password_confirmation:"Secret"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password not having a capital letter" do
    user = User.create username:"Pekka", password:"secret", password_confirmation:"secret"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password having only numbers" do
    user = User.create username:"Pekka", password:"1111", password_confirmation:"1111"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){ FactoryGirl.create(:user)}

    it "has method for determining the favorite beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "with a proper password" do
    let(:user) { FactoryGirl.create(:user)}

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryGirl.create(:user)}
    it "has method for determining the favorite style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "doesn't exist if user hasn't rated any beers" do
      expect(user.favorite_style).to eq(nil)
    end

    it "with only one beer rated returns that beer's style" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_style.name).to eq("anonymous")
    end

    it "returns the highest rated style when having one of each style rated" do
      beer1 = FactoryGirl.create(:beer)
      beer2 = FactoryGirl.create(:beer2)
      beer3 = FactoryGirl.create(:beer3)

      rating1 = FactoryGirl.create(:rating, score:10, beer:beer1, user:user)
      rating2 = FactoryGirl.create(:rating, score:15, beer:beer2, user:user)
      rating3 = FactoryGirl.create(:rating, score:20, beer:beer3, user:user)

      expect(user.favorite_style.name).to eq("anonymous")
    end

    it "returns the highest rated style when having multiple of styles rated" do
      beer1 = FactoryGirl.create(:beer)
      beer2 = FactoryGirl.create(:beer)
      beer3 = FactoryGirl.create(:beer)

      beer4 = FactoryGirl.create(:beer2)
      beer5 = FactoryGirl.create(:beer2)
      beer6 = FactoryGirl.create(:beer2)

      beer7 = FactoryGirl.create(:beer3)
      beer8 = FactoryGirl.create(:beer3)

      rating1 = FactoryGirl.create(:rating, score:10, beer:beer1, user:user)
      rating2 = FactoryGirl.create(:rating, score:15, beer:beer2, user:user)
      rating3 = FactoryGirl.create(:rating, score:20, beer:beer3, user:user)

      rating4 = FactoryGirl.create(:rating, score:30, beer:beer4, user:user)
      rating5 = FactoryGirl.create(:rating, score:35, beer:beer5, user:user)
      rating6 = FactoryGirl.create(:rating, score:40, beer:beer6, user:user)

      rating7 = FactoryGirl.create(:rating, score:20, beer:beer7, user:user)
      rating8 = FactoryGirl.create(:rating, score:25, beer:beer8, user:user)

      expect(user.favorite_style.name).to eq("anonymous")
    end
  end

  describe "favorite brewery" do
    let(:user) { FactoryGirl.create(:user)}


    it "has method for favorite brewery" do
       expect(user).to respond_to(:favorite_brewery)
    end

    it "doesn't exist if user hasn't rated any beers" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "with only one beer rated returns that" do
      beer = create_beer_with_rating(user, 10)
      brewery = FactoryGirl.create(:brewery)
      beer.brewery = brewery

      expect(user.favorite_brewery.name).to eq("anonymous")
    end

    it "returns the highest rated brewery when having one of each brewery rated" do
      beer1 = FactoryGirl.create(:beer)
      beer2 = FactoryGirl.create(:beer2)
      beer3 = FactoryGirl.create(:beer3)

      brewery2 = FactoryGirl.create(:brewery2)
      brewery3 = FactoryGirl.create(:brewery3)
      brewery4 = FactoryGirl.create(:brewery4)

      rating1 = FactoryGirl.create(:rating, score:10, beer:beer1, user:user, brewery:brewery2)
      rating2 = FactoryGirl.create(:rating, score:15, beer:beer2, user:user, brewery:brewery3)
      rating3 = FactoryGirl.create(:rating, score:20, beer:beer3, user:user, brewery:brewery4)

      expect(user.favorite_brewery.name).to eq("brewery4")
    end
  end

  def create_beer_with_rating(user, score)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings(user, *scores)
    scores.each do |score|
      create_beer_with_rating(user,score)
    end
  end
end
