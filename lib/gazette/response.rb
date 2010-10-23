module Gazette
  # Container class for response from the Instapaper API.
  # @author Jeff Pollard
  class Response
    # Successful response from the Instapaper API
    # @author Jeff Pollard
    class Success < Response
      
      # Final saved URL of the content returned from the Instapaper API.
      attr_reader :content_location
      
      # Saved title of the content returned from the Instapaper API.
      attr_reader :instapaper_title
      
      # Create a new Success object out of a net/http response.
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
    
    # Response raised of the Instapaper returned a response indicating invalid user
    # credentials.
    class InvalidCredentials < Exception; end
    
    # Retponse raised if the Instapaper returned a server error (500).
    class ServerError < Exception; end
    
    # Response returned if there was some other type of unknown error.
    class UnknownError < Exception; end
        
  end
end