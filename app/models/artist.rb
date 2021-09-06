class Artist < ActiveRecord::Base
    # tell the Artist class that each artist object can have many songs 
    # since our songs table has an artist_id column & Artist class uses has_many macro, and artist has many songs
    has_many :songs
    # artist has many genres through songs
    has_many :genres, through: :songs
end
