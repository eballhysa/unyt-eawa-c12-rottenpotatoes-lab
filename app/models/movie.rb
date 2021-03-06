class Movie < ApplicationRecord

  def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end #  shortcut: array of strings

  @@grandfathered_date = Date.parse('1 Nov 1968')

  has_many :reviews
  has_many :moviegoers, :through => :reviews

  validates :title, presence: true
  validates :release_date, presence: true
  validate :released_1930_or_later # uses custom validator below
  validates :rating, inclusion: {in: Movie.all_ratings}, unless: :grandfathered?

  scope :with_good_reviews, lambda { |threshold|
    Movie
      .joins(:reviews)
      .group(:movie_id)
      .having(['AVG(reviews.potatoes) > ?', threshold.to_i])
  }
  scope :for_kids, lambda {
    Movie.where('rating in (?)', %w(G PG))
  }
  scope :recently_added, lambda { |threshold|
    Movie.where('created_at > ?', Time.now - threshold)
  }

  def average_score
    self.reviews.average(:potatoes)
  end

  def number_of_reviews
    self.reviews.count
  end

  def released_1930_or_later
    errors.add(:release_date, 'must be 1930 or later') if
        release_date && release_date < Date.parse('1 Jan 1930')
  end

  def grandfathered?
    release_date && release_date < @@grandfathered_date
  end

end