class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                      length: { minimum: 3, maximum: 15}
  validates :password, length: { minimum: 4 }

  validates_format_of :password, with: /(?=.*\d)(?=.*([A-Z]))/, :message => "must have at least one capital letter and one digit"

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  has_many :breweries, -> { uniq}, through: :beers

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if beers.empty?
    styles = Hash.new
    ratings.each do |r|
      if styles[r.beer.style].nil?
        styles[r.beer.style] = Array.new(2)
        set_initial_count_and_score(styles, r)
      end
      styles[r.beer.style][0] += r.score
      styles[r.beer.style][1] += 1
    end
    averages = total_rating_averages(styles)
    get_element_with_highest_rating(averages)
  end

  def favorite_brewery
    return nil if beers.empty?
    breweries = Hash.new
    ratings.each do |r|
      if breweries[r.brewery.name].nil?
        breweries[r.brewery.name] = Array.new(2)
        set_initial_count_and_score_for_brewery(breweries, r)
      end
      breweries[r.brewery.name][0] += r.score
      breweries[r.brewery.name][1] += 1
    end
    averages = total_rating_averages(breweries)
    name = get_element_with_highest_rating(averages)
    find_brewery_by_brewery_name(name)
  end

  private

    def find_brewery_by_brewery_name(name)
      breweries.find { |b| b.name = name}
    end

    def get_element_with_highest_rating(averages)
      averages.max_by{ |k, v| v}[0]
    end

    def total_rating_averages(hash)
      averages = Hash.new
      hash.each do |k, array|
        averages[k] = count_rating_average(array)
      end
      averages
    end

    def count_rating_average(array)
      array[0] / array[1]
    end

    def set_initial_count_and_score(styles, rating)
      set_initial_count(styles, rating)
      set_initial_score(styles, rating)
    end

    def set_initial_count(styles, rating)
      styles[rating.beer.style][1] = 0
    end

    def set_initial_score(styles, rating)
      styles[rating.beer.style][0] = 0
    end

    def set_initial_count_and_score_for_brewery(breweries, rating)
      set_initial_count_for_brewery(breweries, rating)
      set_initial_score_for_brewery(breweries, rating)
    end

    def set_initial_count_for_brewery(breweries, rating)
      breweries[rating.beer.brewery.name][1] = 0
    end

    def set_initial_score_for_brewery(breweries, rating)
      breweries[rating.beer.brewery.name][0] = 0
    end

end
