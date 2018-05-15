module GitShelf
  class Cli < Thor
    class_option :config_path, type: :string

    desc "get CATEGORY URL", "Get a repository from URL and put it into CATEGORY directory."

    def get(category, url)
      config = load_config

      category_dir = config.shelf.path.join(category)
      if !category_dir.exist?
        puts "Directory does not exist: #{category_dir}."
        answer = ask('Do you make this directory and clone in it? [yes/no] ')
        unless answer.match('yes')
          puts 'Cancel to clone a repository.'
          return
        end
      end

      repository = GitShelf::Repository.from_url(config.shelf.path, url, category, Time.now)
      begin
        repository.shallow_clone
      rescue StandardError => ex
        puts ex
      end

      repository_book = GitShelf::RepositoryBook.load(config)
      repository_book.save(config.repository_book.path)
    end

    desc "list [CATEGORY]", "list repository paths each category"
    option :absolute_path, type: :boolean

    def list(category = nil)
      config = load_config

      repository_book = GitShelf::RepositoryBook.load(config)
      repositories = repository_book.repositories

      items = category.nil? ? repositories : repositories.select {|r| r.category == category}
      puts items.map {|r|
        if options[:absolute_path]
          r.path
        else
          r.path.relative_path_from(config.shelf.path)
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

    def count(category = nil)
      config = load_config
      repository_book = GitShelf::RepositoryBook.load(config)
      puts repository_book.repositories.count(category).to_table
    end

    desc "countable", "List countable category of repositories from cached yml. You can use it on count command."

    def countable
      config = load_config
      repository_book = GitShelf::RepositoryBook.load(config)
      puts repository_book.repositories.first.to_h.keys
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