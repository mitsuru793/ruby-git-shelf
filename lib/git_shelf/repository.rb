require 'uri'

module GitShelf
  class Repository
    # @return [String]
    attr_reader :name

    # @return [String]
    attr_reader :author

    # @return [String]
    attr_reader :host

    # @return [String]
    attr_reader :url

    # @return [String, nil]
    attr_reader :category

    # @return [Time]
    attr_reader :cloned_at

    # @param name [String] repository name
    # @param author [String] repository author
    # @param host [String] domain has repository
    # @param category [String, nil]
    # @param cloned_at [Time]
    def initialize(name, author, host, category, cloned_at)
      @name = name
      @author = author
      @host = host
      @url = sprintf('https://%s/%s/%s', host, author, name)
      @category = category
      @cloned_at = cloned_at
    end

    # @param url [String] ex: 'https://github.com/mitsuru793/ruby-git-shelf'
    # @param category [String, nil]
    # @param cloned_at [Time]
    # @return [self]
    def self.from_url(url, category, cloned_at)
      uri = URI.parse(url)
      (author, name) = uri.path.sub(/^\//, '').split('/')
      new(name, author, uri.host, category, cloned_at)
    end

    # @param path [String] ex: 'github.com/mitsuru793/ruby-git-shelf'
    # @param category [String, nil]
    # @return [self]
    def self.from_path(path, category)
      (host, author, name) = path.split('/').slice(-3, 3)
      url = "https://#{host}/#{author}/#{name}"
      self.from_url(url, category, File::Stat.new(path).birthtime)
    end

    # @param directory [String] ex: 'github.com/mitsuru793/ruby-git-shelf'
    # @return [void]
    def shallowClone(directory)
      `git clone --depth 1 #{@url} #{directory}`
    end

    # @return [Hash]
    def to_h
      {
          url: @url,
          name: @name,
          author: @author,
          host: @host,
          category: @category,
          cloned_at: @cloned_at,
      }
    end
  end
end
