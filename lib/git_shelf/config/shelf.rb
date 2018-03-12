require 'pathname'

module GitShelf::Config
  class Shelf
    # @return [Pathname]
    attr_reader :path

    # @param [String]
    def initialize(path)
      @path = Pathname.new(path).expand_path
    end
  end
end
