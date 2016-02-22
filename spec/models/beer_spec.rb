require 'rails_helper'

RSpec.describe Beer, type: :model do
  style = FactoryGirl.create :style
  it "is saved with a name and style" do

    beer = Beer.create name:"beer1", style:style

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved when name isn't given" do
    beer = Beer.create style:style

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved when style isn't given" do
    beer = Beer.create name:"beer1"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
