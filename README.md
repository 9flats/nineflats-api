Read about the API here: http://9flats.github.com/api_docs/

### How to update this gem

    $ git clone git@github.com:9flats/nineflats-api.git

[make your changes]

    $ git commit -am "my changes"
    $ git push
    $ rake install
    $ gem push pkg/nineflats-api-0.0.3.gem
    
When you push a new gem version, update the [nineflats-api-example](https://github.com/9flats/nineflats-api-example) app to use the latest one. You need to change the version in the `Gemfile`, and you might to adapt the code, too.

