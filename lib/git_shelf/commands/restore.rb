module GitShelf
  module Commands
    class Restore < GitShelf::Command
      def main
        config = load_config
        unless config.repository_book.path.exist?
          puts 'No cache file: ' + config.repository_book.path.to_s
          return
        end

        repository_book = GitShelf::RepositoryBook.load(config)
        repository_book.repositories.each do |repo|
          begin
            repo.shallow_clone(config.shelf.path)
          rescue StandardError => ex
            puts ex
          end
        end
      end
    end
  end
end
