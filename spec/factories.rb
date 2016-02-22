FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end

  factory :style do
    name "anonymous"
  end

  factory :brewery, class: Brewery do
    name "anonymous"
    year 1900
  end

  factory :brewery2, class: Brewery do
    name "brewery2"
    year 1900
  end

  factory :brewery3, class: Brewery do
    name "brewery3"
    year 1900
  end

  factory :brewery4, class: Brewery do
    name "brewery4"
    year 1900
  end

  factory :brewery5, class: Brewery do
    name "brewery5"
    year 1900
  end

  factory :beer do
    name "anonymous"
    brewery
    style
  end

  factory :beer2, class: Beer do
    name "anonymous"
    brewery
    style
  end

  factory :beer3, class: Beer do
    name "anonymous"
    brewery
    style
  end

  factory :beer4, class: Beer do
    name "anonymous"
    brewery
    style
  end

  factory :beer5, class: Beer do
    name "anonymous"
    brewery
    style
  end

end