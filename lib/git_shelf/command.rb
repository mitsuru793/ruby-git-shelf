module GitShelf
  class Command < Thor::Group
    class_option :config_path, type: :string

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