require "net/http"
require "net/https"
require "openssl"
require "pp"

module Gazette
  # The Client class interacts with the Instapaper API.  Client hold user authentication
  # information, as well as provide methods to authenticate user credentials and add URLs
  # to their user's Instapaper account.
  # @author Jeff Pollard
  class Client
    
    attr_reader :username
    attr_reader :password
    
    # Create a new client.  Instapaper requires a user username.  Most Instapaper users
    # <b>don't</b> have a password, as such it is optional
    # 
    # @param [String] username Instapaper username
    # @param [Hash] options Additional client options
    # @option options [String] :password Instapaper username
    # @option options [Boolean] :https (false) Interact with the Instapaper API over
    #  HTTPS.
    def initialize(username, options = {})
      raise ArgumentError.new("2nd parameter must be a Hash") unless options.is_a?(Hash)
      @username = username
      @password = options.delete(:password)
      @options = options
      @https = !!(options.delete(:https))
    end
    
    # Attempts to authenticate the client's user credentials with Instapaper.
    # 
    # @param [Hash] options Additional authentication options
    # @option options [String] :jsonp (nil) Returns results as JSON to the specified
    #   Javascript callback.
    # @return [Response::Success] Successful response from the Instapaper API.
    # @raise [Response::InvalidCredentials]
    # @raise [Response::ServerError]
    # @raise [Response::UnknownError]
    def authenticate(options = {})
      parse_response_for request(:authenticate, options)
    end
    
    # Adds a URL to a user's instapaper account
    # 
    # @param [String] url URL of the content to add.
    # @param [Hash] options Additional add options
    # @option options [String] :title Title of the content.  If omitted, Instapaper will
    #   generate a title.
    # @option options [String] :select Sample/selection of content.
    # @option options [:close] :redirect Response returns "Saved!" string and attempts to 
    #   close its own window after a short delay.
    # @option options [String] :jsonp (nil) Returns results as JSON to the specified
    #   Javascript callback.
    # @return [Response::Success] Successful response from the Instapaper API.
    def add(url, options = {})
      parse_response_for request(:add, options.merge(:url => url))
    end
    
    private
    
    # Handles the response from Instapaper
    # @todo Put the raising logic in the Api class/module, then leave the response return
    # to this method
    def parse_response_for(response)
      case response
        when Net::HTTPOK, Net::HTTPCreated then return Response::Success.new(response)
        when Net::HTTPForbidden then raise Response::InvalidCredentials
        when Net::HTTPInternalServerError then raise Response::ServerError
        else raise Response::UnknownError
      end
    end
    
    # Actually heads out to the internet and performs the request
    # @todo Perhaps put me in the Api class/module?
    def request(method, params = {})
      http = Net::HTTP.new(Api::ADDRESS, (@https ? 443 : 80))
      http.use_ssl = @https
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(Api::ENDPOINT+method.to_s)
      request.basic_auth @username, @password
      request.set_form_data(params)
      http.start { http.request(request) }
    end
    
  end
end