# Gazette

Gazette is a Ruby gem to interact with the [Instapaper API](http://www.instapaper.com/api).  It offers complete functionality with all API features, including authentication and adding URLs to read later, operating over HTTPS and using HTTP basic authentication.

**NOTE: This gem is still in beta.  Production use not suggested, but encoraged**

## Installation

At your favorite shell:

    gem install gazette

## Usage

All interaction with the Instapaper APIis done with an instance of a `Gazette::Client` object.  The constructor requires 1 argument, the user's Instapaper email or username.  The 2nd argument is an optional hash, which currently only looks for the `:password` key to specify the user's password.

    `@client = Gazette::Client.new("user@eample.com", :password => "seeecrets")`
    => #<Gazette::Client:0x101f41cb0 @password=nil, @https=false, @username="user@eample.com", @options={}> 
    
### Authentication

With a client in hand, you can call `#authenticate` to authenticate the user's credentials. Per the API documentation, authentication is totally optional.  It may be useful if you want to verify the credentials provided by a user.

    >> @client.authenticate
    => #<Gazette::Response::Success:0x101f37260 @instapaper_title=nil, @content_location=nil>
    
### Responses
    
All valid responses to the Instapaper API return a `Gazette::Response::Success` object.  All invalid response *raise* one of the following exceptions:

* `Gazette::Response::InvalidCredentials` - invalid user credentials
* `Gazette::Response::ServerError` - API encountered an error. Please try again later.
* `Gazette::Response::UnknownError` - Some other unknown error.

Thus, for proper error checking, please `rescue` 

### Adding URLs

To add URLs to the client's Instapaper account, call `#add(url)`.

    >> @client.add("http://patmaddox.com/blog/2010/5/9/a-response-to-unit-and-functional-tests-are-as-useful-as-100.html", :title => "How do you write 100% correct code?", :selection => "How do you guarantee an application's correctness?")
    => #<Gazette::Response::Success:0x101f17a00 @instapaper_title="\"How do you write 100% correct code?\"", @content_location="http://patmaddox.com/blog/2010/5/9/a-response-to-unit-and-functional-tests-are-as-useful-as-100.html">
    
The `#add` method takes only one required parameter, a string of the URL you want to add.  The 2nd parameter is an options hash, which can contain any of the following.  All of these are completely optional and Instapaper will still add the URL without them.  See the [Instapaper API documentation](http://www.instapaper.com/api) for details:

* `:title => "string"`
* `:selection => "string"`
* `:redirect => :close` which attempts to close the window after a short delay.
* `:jsonp => "string"`


## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Jeff Pollard. See LICENSE for details.