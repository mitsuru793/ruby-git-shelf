require 'find'

require 'git_shelf/counter'

module GitShelf
  class Repositories
    include Enumerable

    # @param repositories [Array<Repository>]
    def initialize(repositories)
      @items = repositories
    end

    # @param root [String]
    # @return self
    def self.from_root_path(root)
      repositories = []
      Find.find(root) {|path|
        next unless Dir.exist?(File.join(path, '.git'))
        repository = GitShelf::Repository.from_path(root, path)
        repositories.push(repository)
        Find.prune
      }
      new(repositories)
    end

    # @param root [String] git shelf root path
    # @param repositories_data [Array<Hash>]
    # @return self
    def self.from_array(root, repositories_data)
      repositories = []
      repositories_data.each do |repo|
        repositories.push(GitShelf::Repository.new(
            root, repo[:name], repo[:author], repo[:host], repo[:category], repo[:cloned_at]
        ))
      end
      return new(repositories)
    end

    def each
      @items.map {|item| yield item}
    end

    # @return [Array<Hash>]
    def to_a
      @items.map {|repo| repo.to_h}
    end

    # @param key [String] count key of repository
    # @return [Counter]
    def count(key)
      counter = GitShelf::Counter.new(key)
      @items.each do |repo|
        counter.succ!(repo.instance_variable_get("@#{key}"))
      end
      counter
    end

    # @param repository [Repository]
    # @return [void]
    def push(repository)
      @items.push(repository)
    end

    # @return [Integer]
    def size
      @items.size
    end
  end
end
