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

    # @param name [String] repository name
    # @param author [String] repository author
    # @param host [String] domain has repository
    def initialize(name, author, host)
      @name = name
      @author = author
      @host = host
      @url = sprintf('https://%s/%s/%s', host, author, name)
    end

    # @param url [String] ex: 'https://github.com/mitsuru793/ruby-git-shelf'
    # @return [self]
    def self.from_url(url)
      uri = URI.parse(url)
      (author, name) = uri.path.sub(/^\//, '').split('/')
      new(name, author, uri.host)
    end

    # @param path [String] ex: 'github.com/mitsuru793/ruby-git-shelf'
    # @return [self]
    def self.from_path(path)
      (host, author, name) = path.split('/').slice(-3, 3)
      url = "https://#{host}/#{author}/#{name}"
      self.from_url(url)
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
      }
    end
  end
end
