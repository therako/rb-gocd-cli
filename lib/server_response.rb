module Gocd
  class ServerResponse
    attr_accessor :data, :code

    def self.parse(response)
      server_response = ServerResponse.new
      server_response.code = response.code
      case response
        when Net::HTTPSuccess
          server_response.data = JSON.parse response.body
        when Net::HTTPUnauthorized
          server_response.data = {'error' => "#{response.message}: Ensure username and password set and correct?"}
        when Net::HTTPServerError
          server_response.data = {'error' => "#{response.message}: try again later?"}
        else
          server_response.data = {'error' => response.message}
      end
      server_response
    end

    def self.not_found(msg)
      server_response = ServerResponse.new
      server_response.code = 404
      server_response.data = msg
      server_response
    end

    def is_ok?
      @code == '200'
    end
  end
end
