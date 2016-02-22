require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end
  end

  describe "ratings shown on user's page" do
    let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
    let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }

    it "don't exist when user hasn't done any ratings" do
      visit user_path(1)
      expect(page).to have_content "hasn't made any ratings yet"
    end

    it "show user has rated one beer when the user has done it" do
      user = FactoryGirl.create(:user, username:"Pate")

      FactoryGirl.create(:rating, score:10, beer:beer1, user:user)
      visit user_path(2)


      expect(page).to have_content "has 1 rating with an average of 10.0"
    end

    it "don't exist when user has deleted ratins" do
      user = FactoryGirl.create(:user, username:"Pate")
      sign_in(username:"Pate", password:"Foobar1")

      FactoryGirl.create(:rating, score:10, beer:beer1, user:user)
      visit user_path(2)
      expect(page).to have_content "has 1 rating with an average of 10.0"

      click_link("delete")

      expect(page).to have_content "hasn't made any ratings yet"
    end

  end

  describe "favorites" do
    let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
    let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }

    describe "favorite beer" do

      it "is not shown when user hasn't rated anything" do
        visit user_path(1)
        expect(page).to_not have_content "favorite beer"
      end

      it "is shown when user has rated one beer" do
        user = FactoryGirl.create(:user, username:"Pate")
        FactoryGirl.create(:rating, score:10, beer:beer1, user:user)

        visit user_path(2)

        expect(page).to have_content "favorite beer: iso 3"
      end
    end

    describe "favorite style" do

      it "is not shown when user hasn't rated anything" do
        visit user_path(1)
        expect(page).to_not have_content "favorite style"
      end

      it "is shown when user has rated one beer" do
        user = FactoryGirl.create(:user, username:"Pate")
        FactoryGirl.create(:rating, score:10, beer:beer1, user:user)

        visit user_path(2)

        expect(page).to have_content "favorite style: anonymous"
      end
    end

    describe "favorite brewery" do

      it "is not shown when user hasn't rated anything" do
        visit user_path(1)
        expect(page).to_not have_content "favorite brewery"
      end

      it "is shown when user has rated one beer" do
        user = FactoryGirl.create(:user, username:"Pate")
        FactoryGirl.create(:rating, score:10, beer:beer1, user:user)

        visit user_path(2)

        expect(page).to have_content "favorite brewery: Koff"
      end
    end

  end
end