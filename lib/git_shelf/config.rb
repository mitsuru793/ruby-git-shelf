require 'git_shelf/config/base'
require 'git_shelf/config/shelf'

module GitShelf::Config
  # @param path [String]
  # @return [Config::Base]
  def self.load_file(path)
    config_path = Pathname.new(path).expand_path
    config = YAML.load_file(config_path)
    GitShelf::Config::Base.new(
        GitShelf::Config::Shelf.new(config['shelf']['path']),
        GitShelf::Config::Shelf.new(config['repository_book']['path'])
    )
  end
end
