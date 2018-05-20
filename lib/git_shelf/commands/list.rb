module GitShelf
  module Commands
    class List < GitShelf::Command
      class_option :absolute_path, type: :boolean

      argument :category, type: :string, optional: true

      def main
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
    end
  end
end