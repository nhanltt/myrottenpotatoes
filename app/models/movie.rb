# movie data handling class using ActiveRecord
class Movie < ActiveRecord::Base
    # define class movie is inherit from StandardError
    class Movie::InvalidKeyError < StandardError; end
    
    has_many :reviews
    
    scope :with_good_reviews, -> (threshold = 6){
        Movie.joins(:reviews).group(:movie_id).
        having(['AVG(reviews.potatoes) >= ?', threshold])
    }
    scope :for_kids, -> {
        where('rating = ? or rating = ?', %w(G), %w(PG))
    }
    
    scope :recently_reviewed, lambda { |day|
        Movie.joins(:reviews).where(['reviews.created_at >= ?', day.days.ago]).uniq
    }

    Tmdb::Api.key("3de73563163d0a3aa04a64b3fbd855fd") 
    def self.find_in_tmdb(string)
        begin
        Tmdb::Movie.find(string)
        rescue Tmdb::InvalidApiKeyError
            raise Movie::InvalidKeyError, 'Invalid API key'
        end
    end

    def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end #  shortcut: array of strings
    
    validates :title, :presence => true
    validates :release_date, :presence => true
    validate :released_1930_or_later # uses custom validator below
    validates :rating, :inclusion => {:in => Movie.all_ratings},
        :unless => :grandfathered?

    def released_1930_or_later
        errors.add(:release_date, 'must be 1930 or later') if
        release_date && release_date < Date.parse('1 Jan 1930')
    end
    
    # @@grandfathered_date = Date.parse('1 Nov 1968')
    def grandfathered?
        release_date && release_date >= Date.parse('1 Nov 1968')
    end
    
    before_save :capitalize_title
    def capitalize_title
      self.title = self.title.split(/\s+/).map(&:downcase).
        map(&:capitalize).join(' ')
    end

end