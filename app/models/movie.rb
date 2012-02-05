class Movie < ActiveRecord::Base
  def self.ratings
  	ratings = []
    records = self.find(:all, :select => 'rating', :group => 'rating')
    records.each do |record|
    	ratings << record.rating
    end
    ratings
  end
end
