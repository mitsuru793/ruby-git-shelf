require 'find'

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
        repository = GitShelf::Repository.from_path(path)
        repositories.push(repository)
        Find.prune
      }
      new(repositories)
    end

    # @return [Array<Hash>]
    def to_a
      @items.map {|repo| repo.to_h}
    end
  end
end