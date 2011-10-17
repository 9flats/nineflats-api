Read about the API here: http://9flats.github.com/api_docs/

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
    
#### Same thing with the user:

    user = User.fetch("jana-k-1")
    user.name
    user.favorites

#### Search for places:

    places = Place.search({:query => "Berlin", :number_of_beds => 4})
    

### How to update this gem

    $ git clone git@github.com:9flats/nineflats-api.git

[make your changes]

    $ git commit -am "my changes"
    $ git push
    $ rake install
    $ gem push pkg/nineflats-api-0.0.3.gem
    
When you push a new gem version, update the [nineflats-api-example](https://github.com/9flats/nineflats-api-example) app to use the latest one. You need to change the version in the `Gemfile`, and you might to adapt the code, too.

