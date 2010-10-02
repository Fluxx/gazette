module Gazette
  class Response

    class Success; end
    class InvalidCredentials < Exception; end
    class ServerError < Exception; end
    class UnknownError < Exception; end
        
  end
end