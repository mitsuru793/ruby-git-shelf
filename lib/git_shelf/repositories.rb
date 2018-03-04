require 'find'

require 'git_shelf/counter'

module GitShelf
  class Repositories
    # @return [Array<Repository>]
    attr_reader :items

    def initialize(repositories)
      @items = repositories
    end

    # @param root [String]
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

    def self.from_array(root, repositories_data)
      repositories = []
      repositories_data.each do |repo|
        repositories.push(GitShelf::Repository.new(
            root, repo[:name], repo[:author], repo[:host], repo[:category], repo[:cloned_at]
        ))
      end
      return new(repositories)
    end

    # @return [Array<Hash>]
    def to_a
      @items.map {|repo| repo.to_h}
    end

    def count(key)
      counter = GitShelf::Counter.new(key)
      @items.each do |repo|
        counter.succ!(repo.instance_variable_get("@#{key}"))
      end
      counter
    end
  end
end
