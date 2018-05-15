module GitShelf
  class Git
    class << self
      # @param src [String]
      # @param dest [String]
      # @param options [Array]
      def clone(src, dest, options)
        command('clone', options, src, dest)
      end

      private
      # @param command [String]
      # @param options [Array]
      # @param args [Array]
      def command(command, options, *args)
        system('git', command, options.join(' '), *args)
      end
    end
  end
end