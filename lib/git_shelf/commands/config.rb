module GitShelf
  module Commands
    class Config < GitShelf::Command
      argument :dotPath, type: :string

      def main
        config = load_config
        path = dotPath.split('.').map(&:to_sym)
        puts config.to_h.dig(*path)
      end
    end
  end
end
