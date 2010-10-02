require "net/http"
require "uri"

module Gazette
  class Client

    attr_reader :username
    attr_reader :password
    
    # TODO: http/https choice
    ENDPOINT = "http://www.instapaper.com/api/".freeze

    # Build a new client with the supplied username and options
    def initialize(username, options = {})
      @username = username
      @password = options.delete(:password)
      @options = options
    end
    
    # Attempts to authenticate
    def authenticate
      case request(:authenticate, request_options)
        when Net::HTTPOK then return Response::Success.new
        when Net::HTTPForbidden then raise Response::InvalidCredentials
        when Net::HTTPInternalServerError then raise Response::ServerError
        else raise Response::UnknownError
      end
    end
    
    private
    
    # Actually heads out to the internet and performs the request
    def request(method, params = {})
      uri = URI.parse(ENDPOINT + method.to_s)
      Net::HTTP.new(uri.host).head(uri.path)
    end
    
    # Build options for the request based on what's passed in
    def request_options
      Hash.new.tap do |hash|
        hash[:username] if @username
        hash[:password] if @password
      end
    end

  end
end