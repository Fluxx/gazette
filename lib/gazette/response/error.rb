module Gazette
  class Response
    
    # Superclass for all Gazette::Errors
    class Error < StandardError; end
    
    # Response raised of the Instapaper returned a response indicating invalid user
    # credentials.
    class InvalidCredentials < Error; end
    
    # Retponse raised if the Instapaper returned a server error (500).
    class ServerError < Error; end
    
    # Response returned if there was some other type of unknown error.
    class UnknownError < Error; end
        
  end
end