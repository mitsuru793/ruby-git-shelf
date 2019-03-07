module GitShelf
  class Cli < Thor
    class_option :config_path, type: :string

    register(GitShelf::Commands::Get, 'get', 'get CATEGORY URL', 'Get a repository from URL and put it into CATEGORY directory.')

    register(GitShelf::Commands::List, 'list', 'list [CATEGORY]', 'list repository paths each category')

    register(GitShelf::Commands::Dump, 'dump', 'dump', 'Dump repositories directory tree as a yaml.')

    register(GitShelf::Commands::Restore, 'restore', 'restore', 'Clone repositories from a cached yaml.')

    register(GitShelf::Commands::Count, 'count', 'count CATEGORY', 'Count CATEGORY of repositories from cached yml. CATEGORY is listed on countable command.')

    register(GitShelf::Commands::Countable, 'countable', 'countable', 'List countable category of repositories from cached yml. You can use it on count command.')

    register(GitShelf::Commands::Config, 'config', 'config DOT_PATH', 'Get cache value by dot path like git config. ex: shelf.path')

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