require 'pathname'

module GitShelf::Config
  class RepositoryBook
    # @return [Pathname]
    attr_reader :path

    # @param [String]
    def initialize(path)
      @path = Pathname.new(path).expand_path
    end
  end
end
