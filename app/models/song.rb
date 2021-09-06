# A macro is a method that writes code for us(think metaprogramming)
# By invoking a few methods that come with AR, we can implment all of the assocations we've been discussing 
# Using AR macros(or methods) for has many, has many through, belongs_to
class Song < ActiveRecord::Base
    # tell the Song class that it will produce objects that can belong to an artist and genre
    belongs_to :artist 
    belongs_to :genre

end
