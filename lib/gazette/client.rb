require "net/http"

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
    
    # Adds a URL to a user's instapaper account
    def add(url, options = {})
      case request(:add, options.merge(:url => url))
        when Net::HTTPOK then return Response::Success.new
        when Net::HTTPForbidden then raise Response::InvalidCredentials
        when Net::HTTPInternalServerError then raise Response::ServerError
        else raise Response::UnknownError
      end
    end
    
    private
    
    # Actually heads out to the internet and performs the request
    def request(method, params = {})
      http = Net::HTTP.new(Api::ADDRESS)
      request = Net::HTTP::Post.new(Api::ENDPOINT+method.to_s)
      request.basic_auth @username, @password
      request.set_form_data(params)
      http.start { http.request(request) }
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