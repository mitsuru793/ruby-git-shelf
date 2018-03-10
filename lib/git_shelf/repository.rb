require 'uri'
require 'fileutils'
require 'pathname'

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

    # Linux doesn't implement birthtime. It's needed when dump from existed repositories.
    # So, allow nil.
    # @return [Time, nil]
    attr_reader :cloned_at

    # @return [Pathname]
    attr_reader :path

    # @param root [String] git shelf root path
    # @param name [String] repository name
    # @param author [String] repository author
    # @param host [String] domain has repository
    # @param category [String, nil]
    # @param cloned_at [Time]
    def initialize(root, name, author, host, category, cloned_at)
      @name = name
      @author = author
      @host = host
      @url = sprintf('https://%s/%s/%s', host, author, name)
      @category = category
      @path = Pathname.new(root).join(@category, @host, @author, @name).expand_path
      @cloned_at = cloned_at
    end

    # @param root [String] git shelf root path
    # @param url [String] ex: 'https://github.com/mitsuru793/ruby-git-shelf'
    # @param category [String, nil]
    # @param cloned_at [Time]
    # @return [self]
    def self.from_url(root, url, category, cloned_at)
      uri = URI.parse(url)
      (author, name) = uri.path.sub(/^\//, '').split('/')
      new(root, name, author, uri.host, category, cloned_at)
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
      self.from_url(root, url, category, cloned_at)
    end

    # @return [void]
    def shallow_clone
      raise StandardError.new("Already cloned: #{@path}") if @path.exist?
      FileUtils.mkdir_p(@path)
      system('git', 'clone', '--depth=1', @url, @path)
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
