require 'uri'
require 'fileutils'
require 'pathname'

module GitShelf
  class Repository < Dry::Struct
    attribute :id, Types::Strict::String

    attribute :name, Types::Strict::String

    attribute :author, Types::Strict::String

    attribute :host, Types::Strict::String

    attribute :url, Types::Strict::String

    attribute :category, Types::Strict::String.optional

    attribute :can_clone, Types::Strict::Bool

    # Linux doesn't implement birthtime. It's needed when dump from existed repositories.
    # So, allow nil.
    attribute :cloned_at, Types::Strict::Time.optional

    # @param root [String] git shelf root path
    # @param url [String] ex: 'https://github.com/mitsuru793/ruby-git-shelf'
    # @param category [String, nil]
    # @param cloned_at [Time]
    # @return [self]
    def self.from_url(url, category, cloned_at)
      uri = URI.parse(url)
      (author, name) = uri.path.sub(/^\//, '').split('/')
      id = sprintf('%s/%s/%s', uri.host, author, name)
      url = sprintf('https://%s', id)
      new(id: id, url: url, name: name, author: author, host: uri.host, category: category, can_clone: true, cloned_at: cloned_at)
    end

    # @param root [String] git shelf root path
    # @param path [String] ex: 'github.com/mitsuru793/ruby-git-shelf'
    # @return [self]
    def self.from_path(root, path)
      (category, host, author, name) = path.split('/').slice(-4, 4)
      url = "https://#{host}/#{author}/#{name}"
      begin
        cloned_at = File::Stat.new(path).birthtime
      rescue NotImplementedError
        cloned_at = nil
      end

      self.from_url(url, category, cloned_at)
    end

    # @param root [String]
    # @return [void]
    def shallow_clone(root = '.')
      path = path(root)
      if path.exist? || !can_clone
        return
      end
      FileUtils.mkdir_p(path)
      GitShelf::Git.clone(url, path.to_s, ['--depth=1'])
    end

    # @param root [String]
    # @return [String]
    def path(root = '.')
      Pathname.new(root).join(category, host, author, name)
    end
  end
end
