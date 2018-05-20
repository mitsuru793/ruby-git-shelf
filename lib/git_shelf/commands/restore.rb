module GitShelf
  module Commands
    class Restore < GitShelf::Command
      def main
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
    end
  end
end
