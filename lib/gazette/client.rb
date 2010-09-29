module Gazette
  class Client

    attr_reader :username
    attr_reader :password

    def initialize(username, options = {})
      @username = username
      @password = options.delete(:password)
      @options = options
    end

  end
end