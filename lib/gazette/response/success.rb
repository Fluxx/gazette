module Gazette
  class Response
    
    # Successful response from the Instapaper API
    # @author Jeff Pollard
    class Success < Response
      
      # Final saved URL of the content returned from the Instapaper API.
      attr_reader :content_location
      
      # Saved title of the content returned from the Instapaper API.
      attr_reader :instapaper_title
      
      # The body returned by the Instapaper API
      attr_reader :body
      
      # Create a new Success object out of a net/http response.
      def initialize(response)
        unless response.is_a?(Net::HTTPResponse)
          # Require a net/http response object
          raise ArgumentError.new("Argument must be a Net::HTTPResponse object") 
        end
        
        # Build our ivars from the response and headers
        @body = response.body
        @content_location = response.header['Content-Location']
        @instapaper_title = response.header['X-Instapaper-Title']
      end
    end
    
  end
end