require 'yaml'
require 'pathname'

module GitShelf
  class RepositoryBook
    # @return [Repositories]
    attr_reader :repositories

    # @param repositories [Array]
    def initialize(repositories)
      @repositories = repositories
    end

    # @param config [Config::Base]
    # @return [self]
    def self.load(config)
      book_path = config.repository_book.path
      if book_path.exist?
        repository_book = YAML.load_file(book_path)
        repositories = GitShelf::Repositories.from_array(
            config.shelf.path,
            repository_book['repositories']
        )
      else
        repositories = GitShelf::Repositories.from_root_path(config.shelf.path)
      end
      new(repositories)
    end

    # @string path [Pathname]
    # @return [void]
    def save(path)
      data = {
          'repositories' => @repositories.to_a
      }
      File.open(path, 'w') do |f|
        YAML.dump(data, f)
      end
    end
  end
end