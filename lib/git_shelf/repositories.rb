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
      raise ArgumentError, "No git-shelf exists: #{root}" unless Dir.exist?(root)

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
    # @param repositories_data [Hash<Hash>]
    # @return self
    def self.from_hash(root, repositories_data)
      repositories = []
      repositories_data.each_value do |repo|
        repositories.push(GitShelf::Repository.new(repo))
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

    # @return [Hash<Hash>]
    def to_h
      items = {}
      @items.each do |repo|
        items[repo.id] = repo.to_h
      end
      items
    end

    # @param key [String] count key of repository
    # @return [Counter]
    def count(key)
      counter = GitShelf::Counter.new(key)
      @items.each do |repo|
        counter.succ!(repo.send(key))
      end
      counter
    end

    # @param nth [Integer]
    # @return Repository
    def fetch(nth)
      @items.fetch(nth)
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
