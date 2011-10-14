class Fixtures
  def self.user
    '{
      "user": {
        "name": "Jana K.",
        "slug": "jana-k-1",
        "user_photo_url": "http://img2.9flats.com/users/photos/11405-1311181665/medium.jpg",
        "links": [{
          "rel": "self",
          "href": "http://api.9flats.com/api/users/jana-k-1"
        },
        {
          "rel": "full",
          "href": "http://www.9flats.com/users/jana-k-1"
        },
        {
          "rel": "favorites",
          "href": "http://api.9flats.com/api/users/jana-k-1/favorites"
        }]
      }
    }'
  end
end
