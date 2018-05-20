module GitShelf
  class Cli < Thor
    class_option :config_path, type: :string

    register(GitShelf::Commands::Get, 'get', 'get CATEGORY URL', 'Get a repository from URL and put it into CATEGORY directory.')

    register(GitShelf::Commands::List, 'list', 'list [CATEGORY]', 'list repository paths each category')

    register(GitShelf::Commands::Dump, 'dump', 'dump', 'Dump repositories directory tree as a yaml.')

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

    register(GitShelf::Commands::Count, 'count', 'count CATEGORY', 'Count CATEGORY of repositories from cached yml. CATEGORY is listed on countable command.')

    register(GitShelf::Commands::Countable, 'countable', 'countable', 'List countable category of repositories from cached yml. You can use it on count command.')

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