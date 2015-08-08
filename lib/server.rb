require 'open-uri'
require 'json'

module Gocd
  class Server

    def execute(params)
      return I18n.t('server.errors.no_command') if params.empty?
      command = params.first
      return I18n.t('server.errors.unknown_command') if defined? command
      send(command, params)
    end

   end
end