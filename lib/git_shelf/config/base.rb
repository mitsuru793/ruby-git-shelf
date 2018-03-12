require 'pathname'

module GitShelf::Config
  class Base
    # @return [Config::Shelf]
    attr_reader :shelf

    # @return [Config::RepositoryBook]
    attr_reader :repository_book

    # @param shelf [Config::Shelf]
    # @param repository_book [Config::RepositoryBook]
    def initialize(shelf, repository_book)
      @shelf = shelf
      @repository_book = repository_book
    end
  end
end
