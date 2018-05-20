module GitShelf
  class Cli < Thor
    class_option :config_path, type: :string

    register(GitShelf::Commands::Get, 'get', 'get CATEGORY URL', 'Get a repository from URL and put it into CATEGORY directory.')

    desc "list [CATEGORY]", "list repository paths each category"
    option :absolute_path, type: :boolean

    def list(category = nil)
      config = load_config

      repository_book = GitShelf::RepositoryBook.load(config)
      repositories = repository_book.repositories

      items = category.nil? ? repositories : repositories.select {|r| r.category == category}
      puts items.map {|r|
        if options[:absolute_path]
          r.path(config.shelf.path).expand_path
        else
          r.path
        end
      }.join("\n")
    end

    desc "dump", "Dump repositories directory tree as a yaml."

    def dump
      config = load_config
      repository_book = GitShelf::RepositoryBook.load(config)
      repository_book.save(config.repository_book.path)
    end

    desc "restore", "Clone repositories from a cached yaml."

    def restore
      config = load_config
      repository_book = GitShelf::RepositoryBook.load(config)
      repository_book.repositories.each do |repo|
        begin
          repo.shallow_clone
        rescue StandardError => ex
          puts ex
        end
      end
    end

    desc "count CATEGORY", "Count CATEGORY of repositories from cached yml. CATEGORY is listed on countable command."

    def count(category)
      config = load_config
      repository_book = GitShelf::RepositoryBook.load(config)
      unless GitShelf::Repository.instance_methods(false).include?(category.to_sym)
        puts "Invalid category: #{category}"
        return;
      end
      puts repository_book.repositories.count(category).to_table
    end

    desc "countable", "List countable category of repositories from cached yml. You can use it on count command."

    def countable
      puts GitShelf::Repository.schema.keys
    end

    private
    def load_config
      GitShelf::Config.load_file(options[:config_path] || '~/.git-shelf')
    end

    def ask(prompt = "", newline = false)
      prompt += "\n" if newline
      Readline.readline(prompt, true).squeeze(" ").strip
    end
  end
end