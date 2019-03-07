# stdlib
require 'yaml'
require 'shell'
require 'pathname'

# 3rd party
require "thor"
require 'awesome_print'
require 'dry-struct'

module GitShelf
  module Types
    include Dry::Types.module
    Pathname = Types.Instance(Pathname).constructor {|v| ::Pathname.new(v).expand_path}
  end
end

require "git_shelf/version"
require "git_shelf/repository"
require "git_shelf/repositories"
require "git_shelf/counter"
require "git_shelf/repository_book"
require "git_shelf/config"
require "git_shelf/command"
require "git_shelf/commands/get"
require "git_shelf/commands/list"
require "git_shelf/commands/dump"
require "git_shelf/commands/restore"
require "git_shelf/commands/count"
require "git_shelf/commands/countable"
require "git_shelf/commands/config"
require "git_shelf/cli"
require "git_shelf/git"
