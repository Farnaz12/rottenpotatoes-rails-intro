class Movie < ActiveRecord::Base
    def self.all_ratings
        all_ratings = ["PG", "PG-13", "G", "R"]
    end
    
    def self.with_ratings(ratings_priority)
        Movie.where(:rating => ratings_priority)
    end
end