class Genre < ActiveRecord::Base
    # A genre can have many songs  
    has_many :songs
    # A genre has many artists through its songs 
    has_many :artists, through: :songs
end
