module GitShelf
  module Commands
    class Dump < GitShelf::Command
      def main
        config = load_config
        repository_book = GitShelf::RepositoryBook.load(config)
        repository_book.save(config.repository_book.path)
      end
    end
  end
end