# an artist will have may songs 
# it will have many genres through songs
# through meaning, the table songs is the JOIN table
# the song table has an artist_id & genre_id to combine those 
# two tables together in a many-to-many relationship

# Our artist table just needs a name column
class CreateArtists < ActiveRecord::Migration[4.2]
    def change
    create_table :artists do |t|
      t.string :name
    end
  end
end
