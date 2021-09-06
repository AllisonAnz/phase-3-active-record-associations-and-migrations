# a genre will have many songs, and have many artists through songs

# our genre table just needs a name (id:1 name:pop)
class CreateGenres < ActiveRecord::Migration[4.2]
    def change 
        create_table :genres do |t|
            t.string :name
        end
    end
end
