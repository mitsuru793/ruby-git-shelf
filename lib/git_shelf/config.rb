require 'git_shelf/config/base'
require 'git_shelf/config/shelf'
require 'git_shelf/config/repository_book'

module GitShelf::Config
  # @param path [String]
  # @return [Config::Base]
  def self.load_file(path)
    config_path = Pathname.new(path).expand_path
    config = YAML.load_file(config_path)
    GitShelf::Config::Base.new(
        GitShelf::Config::Shelf.new(config['shelf']['path']),
        GitShelf::Config::RepositoryBook.new(config['repository_book']['path'])
    )
  end
end
