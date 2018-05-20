module GitShelf
  class Cli < Thor
    class_option :config_path, type: :string

    register(GitShelf::Commands::Get, 'get', 'get CATEGORY URL', 'Get a repository from URL and put it into CATEGORY directory.')

    register(GitShelf::Commands::List, 'list', 'list [CATEGORY]', 'list repository paths each category')

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