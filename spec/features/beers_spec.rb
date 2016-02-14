require 'rails_helper'

include Helpers

describe Beer do
  before :each do
    FactoryGirl.create :user
    FactoryGirl.create :brewery
  end

  describe "that is being created" do
    it "with valid name is saved" do
      sign_in(username:"Pekka", password:"Foobar1")

      visit new_beer_path
      fill_in('beer[name]', with:'testBeer1')
      select('Weizen', from:'beer[style]')
      select('anonymous', from:'beer[brewery_id]')

      expect{
        click_button "Create Beer"
      }.to change{Beer.count}.from(0).to(1)
    end

    it "with invalid name is not saved" do
      sign_in(username:"Pekka", password:"Foobar1")

      visit new_beer_path
      select('Weizen', from:'beer[style]')
      select('anonymous', from:'beer[brewery_id]')

      expect{
        click_button "Create Beer"
      }.not_to change{Beer.count}
    end
  end
end