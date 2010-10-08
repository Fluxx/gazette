module Gazette
  class Response

    class Success < Response
      attr_reader :content_location, :instapaper_title
      
      # Create a new Success object out of a net/http response
      def initialize(response)
        unless response.is_a?(Net::HTTPResponse)
          # Require a net/http response object
          raise ArgumentError.new("Argument must be a Net::HTTPResponse object") 
        end
        
        # Build our ivars from the headers
        @content_location = response.header['Content-Location']
        @instapaper_title = response.header['X-Instapaper-Title']
      end
    end
    
    class InvalidCredentials < Exception; end
    class ServerError < Exception; end
    class UnknownError < Exception; end
        
  end
end