module GitShelf
  module Commands
    class Get < GitShelf::Command
      argument :category, type: :string
      argument :url, type: :string

      def main
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

        repository = GitShelf::Repository.from_url(url, category, Time.now)
        begin
          repository.shallow_clone(config.shelf.path)
        rescue StandardError => ex
          puts ex
        end

        repository_book = GitShelf::RepositoryBook.load(config)
        cached =  repository_book.repositories.find {|repo| repo.id === repository.id }
        if !cached
          repository_book.repositories.push(repository)
        end
        repository_book.save(config.repository_book.path)
      end
    end
  end
end