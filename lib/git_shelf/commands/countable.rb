module GitShelf
  module Commands
    class Countable < GitShelf::Command
      def countable
        puts GitShelf::Repository.schema.keys
      end
    end
  end
end
