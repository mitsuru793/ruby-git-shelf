module GitShelf
  module Commands
    class Count < GitShelf::Command
      argument :category, type: :string

      def main
        config = load_config
        repository_book = GitShelf::RepositoryBook.load(config)
        unless GitShelf::Repository.instance_methods(false).include?(category.to_sym)
          puts "Invalid category: #{category}"
          return;
        end
        puts repository_book.repositories.count(category).to_table
      end
    end
  end
end
