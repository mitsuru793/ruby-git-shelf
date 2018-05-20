module GitShelf
  class Config < Dry::Struct
    attribute :shelf do
      attribute :path, Types::Pathname
    end

    attribute :repository_book do
      attribute :path, Types::Pathname
    end

    # @param path [String]
    # @return [self]
    def self.load_file(path)
      config_path = Pathname.new(path).expand_path
      if config_path.symlink?
        config_path = config_path.readlink.expand_path
      end

      config = YAML.load_file(config_path)
      new(
          shelf: {
              path: config['shelf']['path']
          },
          repository_book: {
              path: config['repository_book']['path']
          }
      )
    end
  end
end
