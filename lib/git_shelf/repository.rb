require 'uri'

module GitShelf
  class Repository
    attr_reader :name, :author, :host, :url

    def initialize(name, author, host)
      @name = name
      @author = author
      @host = host
      @url = sprintf('https://%s/%s/%s', host, author, name)
    end

    def self.from_url(url)
      uri = URI.parse(url)
      (author, name) = uri.path.sub(/^\//, '').split('/')
      new(name, author, uri.host)
    end

    def self.from_path(path)
      (host, author, name) = path.split('/').slice(-3, 3)
      url = "https://#{host}/#{author}/#{name}"
      self.from_url(url)
    end

    def shallowClone(directory)
      `git clone --depth 1 #{@url} #{directory}`
    end

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
