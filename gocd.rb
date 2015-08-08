#!/usr/bin/env ruby
require './config/initializers/locale.rb'
require './lib/server'
require 'highline'
require 'cli-console'


class ShellUI
  def initialize
    @gocd_server = Gocd::Server.new
  end

  private
  extend CLI::Task

  public

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

console.addCommand('server', shell.method(:server), 'Go-cd Server')

console.addHelpCommand('help', 'Help')
console.addExitCommand('exit', 'Exit from program')
console.addAlias('quit', 'exit')

console.start("%s> ",[Dir.method(:pwd)])
