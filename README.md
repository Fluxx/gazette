# Gazette

Gazette is a Ruby gem to interact with the [Instapaper API](http://www.instapaper.com/api).  It offers complete functionality with all API features, including authentication and adding URLs to read later.  Gazette operates over HTTP and HTTPS, and uses (Instapaper-preferred) HTTP basic authentication.

* [Github](http://github.com/Fluxx/gazette) - Browse source code, README, etc.
* [Yardoc](http://rubydoc.info/github/Fluxx/gazette/master/frames) - Documentation.
* [Bugs/Issues](http://github.com/Fluxx/gazette/issues) - Got a problem?

**NOTE: This gem is still in beta.  Production use not suggested, but encouraged.**

## Installation

At your favorite shell:

    gem install gazette

## Usage

All interaction with the Instapaper API is done with an instance of `Gazette::Client` object.  The constructor requires one argument, the user's Instapaper email or username.  The 2nd argument is an optional hash, which can contain a `:password => "user_pass"` and/or `:https => true` if you would like to use HTTPS

    @client = Gazette::Client.new("user@eample.com", :password => "seeecrets")
    => #<Gazette::Client:0x101f41cb0 @password=nil, @https=false, @username="user@eample.com", @options={}> 
    
By default Gazette communicates with the Instapaper API over good 'ol HTTP.  You are strongly encouraged to use HTTPS if at all possible.
    
    
### Authentication

With a client in hand, you can call `@client.authenticate` to authenticate the user's credentials. Per the API documentation, authentication is totally optional.  It may be useful if you want to verify the credentials provided by a user, but is not a required step before adding URLs.

    >> @client.authenticate
    => #<Gazette::Response::Success:0x101f37260 @instapaper_title=nil, @content_location=nil>
    
### Responses
    
All valid responses to the Instapaper API return a `Gazette::Response::Success` object.  All invalid response *raise* one of the following exceptions:

* `Gazette::Response::InvalidCredentials` - Invalid user credentials.
* `Gazette::Response::ServerError` - API encountered an error. Please try again later.
* `Gazette::Response::UnknownError` - Some other unknown error.  File a bug...maybe.

Thus, for proper error checking, please `rescue` any/all of the above exceptions.

### Adding URLs

To add URLs to the client's Instapaper account, call `@client.add(url)`:

    >> @client.add("http://patmaddox.com/blog/2010/5/9/a-response-to-unit-and-functional-tests-are-as-useful-as-100.html", :title => "How do you write 100% correct code?", :selection => "How do you guarantee an application's correctness?")
    => #<Gazette::Response::Success:0x101f17a00 @instapaper_title="\"How do you write 100% correct code?\"", @content_location="http://patmaddox.com/blog/2010/5/9/a-response-to-unit-and-functional-tests-are-as-useful-as-100.html">
    
The `#add` method takes only one required parameter, a string of the URL you want to add.  The 2nd parameter is an optional hash, which can contain any of the following.  See the [Instapaper API documentation](http://www.instapaper.com/api) for details:

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