require 'terminal-table'

module GitShelf
  class Counter
    # @param name [string]
    def initialize(name)
      @name = name
      @data = {}
    end

    # @param column [string]
    # @return [void]
    def succ!(column)
      if @data.has_key?(column)
        @data[column] += 1
      else
        @data[column] = 1
      end
    end

    # @return [Terminal::Table]
    def to_table
      Terminal::Table.new(
          headings: [@name.capitalize, 'Count'],
          rows: to_a_sorted
      )
    end

    private
    # @return [Array<Array>]
    def to_a_sorted
      @data.sort_by {|_, count| count}
    end
  end
end
