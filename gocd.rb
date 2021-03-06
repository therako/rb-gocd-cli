#!/usr/bin/env ruby
require './config/initializers/locale.rb'
require './lib/server'
require 'highline'
require 'cli-console'


class ShellUI

  private
  extend CLI::Task

  public

  usage 'Usage: connect go_server_url 8153'
  usage 'with username and password usage: connect go_server_url 8153 username password'
  desc 'List file information about current directory'
  def connect(params)
    @gocd_server = Gocd::Server.new(params)
    response = @gocd_server.verify_connection
    puts response
  end

  usage 'Usage: ls'
  desc 'List file information about current directory'
  def ls(params)
    Dir.foreach(Dir.pwd) do |file|
      puts file
    end
  end

  usage 'Usage: server'
  desc 'For go-cd server based functions'
  def server(params)
    response = @gocd_server.execute(params)
    puts response
  end

end

io = HighLine.new
shell = ShellUI.new
console = CLI::Console.new(io)

console.addCommand('ls', shell.method(:ls), 'List files')

console.addCommand('connect', shell.method(:connect), 'Connect to a Go server to use the app.')

console.addCommand('server', shell.method(:server), 'Go-cd Server')

console.addHelpCommand('help', 'Help')
console.addExitCommand('exit', 'Exit from program')
console.addAlias('quit', 'exit')

console.start("%s> ",[Dir.method(:pwd)])
