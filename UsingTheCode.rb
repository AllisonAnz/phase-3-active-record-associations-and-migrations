Our Code in Action: Working with Associations
Go ahead and run the test suite and you'll see that we are passing all of our tests! Amazing! Our associations are all working, just because of our migrations and use of macros.

Let's play around with our code.

In your console, run rake console. Now we are in a Pry console that accesses our models.

Let's make a few new songs:

[1]pry(main)> hello = Song.new(name: "Hello")
=> #<Song:0x007fc75a8de3d8 id: nil, name: "Hello", artist_id: nil, genre_id: nil>
[2]pry(main)> hotline_bling = Song.new(name: "Hotline Bling")
=> #<Song:0x007fc75b9f3a38 id: nil, name: "Hotline Bling", artist_id: nil, genre_id: nil> 
Okay, here we have two songs. Let's make some artists to associate them to. In the same PRY sessions as above:

[3] pry(main)> adele = Artist.new(name: "Adele")
=> #<Artist:0x007fc75b8d9490 id: nil, name: "Adele">
[4] pry(main)> drake = Artist.new(name: "Drake")
=> #<Artist:0x007fc75b163c60 id: nil, name: "Drake"> 
So, we know that an individual song has an artist_id attribute. We could associate hello to adele by setting hello.artist_id= equal to the id of the adele object. BUT! Active Record makes it so easy for us. The macros we implemented in our classes allow us to associate a song object directly to an artist object:

[5] pry(main)> hello.artist = adele
=> #<Artist:0x007fc75b8d9490 id: nil, name: "Adele"> 
Now, we can ask hello who its artist is:

[6] pry(main)> hello.artist
=> #<Artist:0x007fc75b8d9490 id: nil, name: "Adele"> 
We can even chain methods to ask hello for the name of its artist:

[7] pry(main)> hello.artist.name
=> "Adele" 
Wow! This is great, but we're not quite where we want to be. Right now, we've been able to assign an artist to a song, but is the reverse true?

[7] pry(main)> adele.songs
=> [] 
In this case, we still need to tell the adele Artist instance which songs it has. We can do this by pushing the song instance into adele.songs:

[7] pry(main)> adele.songs.push(hello)
=> [#<Song:0x007fc75a8de3d8 id: nil, name: "Hello", artist_id: nil, genre_id: nil>] 
Okay, now both sides of the relationships are updated, but so far all the work we've done has been with temporary instances of Artist and Song. To persist these relationships, we can use Active Record's save functionality:

[8] pry(main)> adele.save
=> true
[9] pry(main)> adele
=> #<Artist:0x007fc75b8d9490 id: 1, name: "Adele"> 
Notice that adele now has an id. What about hello?

[10] pry(main)> hello
=> #<Song:0x007fc75a8de3d8 id: 1, name: "Hello", artist_id: nil, genre_id: nil> 
Whoa! We didn't mention hello when we saved. However, we established an association by assigning hello as a song adele has. In order for adele to save, hello must also be saved. Thus, hello has also been given an id.

Go ahead and do the same for hotline_bling and drake to try it out on your own.

Adding Additional Associations
Now, let's make a second song for adele:

[8] pry(main)> someone_like_you = Song.new(name: "Someone Like You")
=> #<Song:0x007fc75b5cabc8 id: nil, name: "Someone Like You", artist_id: nil, genre_id: nil>
[8] pry(main)> someone_like_you.artist = adele
=> #<Artist:0x007fc75b8d9490 id: 1, name: "Adele"> 
We've only updated the song, so we should expect that adele is not aware of this song:

[8] pry(main)> someone_like_you.artist
=> #<Artist:0x007fc75b8d9490 id: 1, name: "Adele">
[9] pry(main)> adele.songs
=> [#<Song:0x007fc75b9f3a38 id: 1, name: "Hello", artist_id: 1, genre_id: nil>] 
Even if we save the song, adele will not be updated.

[8] pry(main)> someone_like_you.save
=> true
[8] pry(main)> someone_like_you
=> #<Song:0x007fc75b5cabc8 id: 2, name: "Someone Like You", artist_id: 1, genre_id: nil>
[9] pry(main)> adele.songs
=> [#<Song:0x007fc75b9f3a38 id: 1, name: "Hello", artist_id: 1, genre_id: nil>] 
But lets see what happens when we switch some things around. Creating one more song:

[8] pry(main)> set_fire_to_the_rain = Song.new(name: "Set Fire to the Rain")
=> #<Song:0x007fc75b5cabc8 id: nil, name: "Set Fire to the Rain", artist_id: nil, genre_id: nil> 
Then add the song to adele:

[9] pry(main)> adele.songs.push(set_fire_to_the_rain)
=> [#<Song:0x007fc75b9f3a38 id: 1, name: "Hello", artist_id: 1, genre_id: nil>, #<Song:0x00007feac2be4f38 id: 3, name: "Set Fire to the Rain", artist_id: 1, genre_id: nil>] 
Whoa! Check it out - we did not explicitly save set_fire_to_the_rain, but just by pushing the instance into adele.songs, Active Record has gone ahead and saved the instance. Not only that, notice that the song instance also has an aritstid!_

[8] pry(main)> set_fire_to_the_rain.artist
=> #<Artist:0x007fc75b8d9490 id: 1, name: "Adele"> 
So what is happening? Active Record is doing things for us behind the scenes, but when dealing with associations, it will behave differently depending on which side of a relationship between two models you are updating.

Remember: In a has_many/belongs_to relationship, we can think of the model that has_many as the parent in the relationship. The model that belongs_to, then, is the child. If you tell the child that it belongs to the parent, the parent won't know about that relationship. If you tell the parent that a certain child object has been added to its collection, both the parent and the child will know about the association.

Let's see this in action again. Let's create another new song and add it to adele's songs collection:

[10] pry(main)> rolling_in_the_deep = Song.new(name: "Rolling in the Deep")
=> #<Song:0x007fc75bb4d1e0 id: nil, name: "Rolling in the Deep", artist_id: nil, genre_id: nil> 
[11] pry(main)> adele.songs << rolling_in_the_deep
=> [ #<Song:0x007fc75bb4d1e0 id: 4, name: "Rolling in the Deep", artist_id: 1, genre_id: nil>]
[12] pry(main)> rolling_in_the_deep.artist
=> #<Artist:0x007fc75b8d9490 id: 4, name: "Adele"> 
We added rolling_in_the_deep to adele's collection of songs and we can see the adele knows it has that song in the collection and rolling_in_the_deep knows about its artist. Not only that, rolling_in_the_deep is now persisted to the database.

Notice that adele.songs returns an array of songs. When a model has_many of something, it will store those objects in an array. To add to that collection, we use the shovel operator, <<, to operate on that collection, and treat adele.songs like any other array.

Let's play around with some genres and our has many through association.

[13] pry(main)> pop = Genre.create(name: "pop")
=> #<Genre:0x007fa34338d270 id: 1, name: "pop"> 
This time, we'll just use create directly, which would be the same as running Genre.new, then Genre.save.

[14] pry(main)> pop.songs << rolling_in_the_deep
=> [#<Song:0x007fc75bb4d1e0 id: 4, name: "Rolling in the Deep", artist_id: 1, genre_id: 1>]
[15] pry(main)> pop.songs
=> [#<Song:0x007fc75bb4d1e0 id: 4, name: "Rolling in the Deep", artist_id: 1, genre_id: 1>]
[16] pry(main)> rolling_in_the_deep.genre
=> #<Genre:0x007fa34338d270 id: 1, name: "pop"> 
It's working! But even cooler is that we've established has many through relationships. By creating a genre, then pushing a song into that genre's list of songs, the genre will now be able to produce its associated artists!

[16] pry(main)> rolling_in_the_deep.artist
=> #<Genre:0x007fa34338d270 id: 1, name: "pop">
[17] pry(main)> pop.artists
=> [#<Artist:0x007fc75b8d9490 id: 1, name: "Adele">]
[28] pry(main)> adele.genres
=> [#<Genre:0x007fa34338d270 id: 1, name: "pop">] 