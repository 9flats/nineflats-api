This gem helps you to use the 9flats.com API in your Ruby code. It always uses the latest API version. The current API version is 1.0.

Find the full API documentation here: http://9flats.github.com/api_docs/

### Usage

Just a few examples:

#### Get a place with all its attributes:

    place = Place.fetch("schner-wohnen-im-belgischen")
    place.name
    place.city
    
#### Get more infos about the place:

    place.photos
    place.reviews
    place.prices
    place.calendar(2011, 10)
    
Except for the calendar, all data is cached.
    
#### Get info about a user:

    user = User.fetch("jana-k-1")
    user.name
    user.favorites

The user's favorites is an array of places, see above.

#### Search for places:

The search accepts all search parameters, [see the API documentation](http://9flats.github.com/api_docs/places.html).

    result = Place.search({:query => "Berlin", :number_of_beds => 4})

The result is a Nineflats::PaginatedArray. It contains the places that match the search queries. The default number of places you get is 9. The result also contains information about the search result, like
    
    result.total_entries
    result.total_pages
    result.current_page
    result.per_page
    
You can also get the next 9 places:

    result.next_page


### How to update this gem

    $ git clone git@github.com:9flats/nineflats-api.git

[make your changes]

    $ git commit -am "my changes"
    $ git push
    $ rake install
    $ gem push pkg/nineflats-api-0.0.3.gem
    
When you push a new gem version, update the [nineflats-api-example](https://github.com/9flats/nineflats-api-example) app to use the latest one. You need to change the version in the `Gemfile`, and you might to adapt the code, too.

