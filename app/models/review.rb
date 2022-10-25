class Review < ActiveRecord::Base
    belongs_to :movie
    belongs_to :moviegoer
    validates :movie_id, :presence => true
    validates_associated :movie, :moviegoer

    scope :wrote_reviews, lambda { |goer_id, movie_id|
        Review.joins(:moviegoer).where('reviews.moviegoer_id = ? and reviews.movie_id = ?', goer_id, movie_id)}

    # scope :has_review_by_user
    def self.all_ratings; %w[1 2 3 4 5] ; end 
end