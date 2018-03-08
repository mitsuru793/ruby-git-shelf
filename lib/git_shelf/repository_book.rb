require 'yaml'

module GitShelf
  class RepositoryBook
    # @return [Repositories]
    attr_reader :repositories

    # @param repositories [Array]
    def initialize(repositories)
      @repositories = repositories
    end

    # @param config [Hash]
    # @return [self]
    def self.load(config)
      book_path = File.expand_path(config[:repository_book])
      if File.exist?(book_path)
        repository_book = YAML.load_file(book_path)
        repositories = GitShelf::Repositories.from_array(
            File.expand_path(config[:shelf]),
            repository_book[:repositories]
        )
      else
        config_path = File.expand_path(config[:shelf])
        repositories = GitShelf::Repositories.from_root_path(config_path)
      end
      new(repositories)
    end

    # @string path [String]
    # @return [void]
    def save(path)
      data = {
          repositories: @repositories.to_a
      }
      File.open(File.expand_path(path), 'w') do |f|
        YAML.dump(data, f)
      end
    end
  end
end