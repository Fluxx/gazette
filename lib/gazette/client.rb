require "net/http"
require "net/https"
require "openssl"
require "pp"

module Gazette
  class Client

    attr_reader :username
    attr_reader :password
    
    # Build a new client with the supplied username and options
    def initialize(username, options = {})
      raise ArgumentError.new("2nd parameter must be a Hash") unless options.is_a?(Hash)
      @username = username
      @password = options.delete(:password)
      @options = options
      @https = !!(options.delete(:https))
    end
    
    # Attempts to authenticate
    def authenticate(options = {})
      parse_response_for request(:authenticate, options)
    end
    
    # Adds a URL to a user's instapaper account
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