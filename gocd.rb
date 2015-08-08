#!/usr/bin/env ruby
require 'highline'
require 'cli-console'


class ShellUI

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

end

io = HighLine.new
shell = ShellUI.new
console = CLI::Console.new(io)

console.addCommand('ls', shell.method(:ls), 'List files')


console.addHelpCommand('help', 'Help')
console.addExitCommand('exit', 'Exit from program')
console.addAlias('quit', 'exit')

console.start("%s> ",[Dir.method(:pwd)])
