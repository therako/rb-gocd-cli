require 'net/http'
require 'json'
require 'uri'
require_relative 'server_response'

module Gocd
  class Server

    ROOT_PATH='go'

    def initialize(params)
      @host=params[0]
      @port=params[1]
      @user=params[2]
      @password=params[3]
    end

    def verify_connection
      gocd_server_response = get('/api/agents')
      return "Connected successfully to #{@host}." if gocd_server_response.is_ok?
      gocd_server_response.data
    end


    def help(_)
      puts 'Available methods are...'
      puts 'verify_connection'
      puts 'help'
    end

    def execute(params)
      return I18n.t('server.errors.no_command') if params.empty?
      command = params.first
      return I18n.t('server.errors.unknown_command') unless respond_to? command
      send(command, params)
    end

    private
      def get(path)
        begin
          url = URI.parse("http://#{@host}:#{@port}/#{ROOT_PATH}#{path}")
          http = Net::HTTP.new(url.host, url.port)
          request = Net::HTTP::Get.new(url)
          request.basic_auth(@user, @password) if @user && @password
          ServerResponse.parse(http.request(request))
        rescue URI::InvalidURIError
          return ServerResponse.not_found("Server not found at http://#{@host}:#{@port}.");
        end
      end

    end
  end
