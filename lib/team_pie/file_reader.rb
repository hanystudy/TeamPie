require 'csv'

module TeamPie
  class FileReader
    attr_accessor :nodes

    def initialize
      @nodes = Nodes.new
    end

    def read(file, type)
      inputs_array = []
      csv_file = CSV.read(file, headers: true).to_a.tap {|data| data.shift}
      csv_file.each_with_index do |row, index|
        @nodes.add(row, type)
      end
      @nodes.post_process(type)
    end

    def branches
      leaves = @nodes.leaves
      @branches = []
      leaves.each do |leaf|
        @branches << @nodes.print_history(leaf.index)
      end
      @branches
    end

    def assign_tasks(count, people)
      @assignments = []
      @people = people.shuffle
      @browsers = ['Safari/Ipad', 'Firefox', 'Chrome'].shuffle
      branches.shuffle.each_with_index do |result, index|
        @assignments[index % count] = [] if @assignments[index % count].nil?
        result.each {|nodes| @assignments[index % count] << nodes}
      end
    end

    def clean_assignments
      @clean_assignments = []
      @assignments.each_with_index do |assigns, index|
        @clean_assignments[index] = build_assign_tree(assigns)
      end
    end

    def print_clean_assignments
      output = ''

      @clean_assignments.each_with_index do |clean, index|
        output << "\n\n=============#{@people[index]}:#{@browsers[index % @browsers.size]}=============\n"
        output << print_clean(clean, '')
      end
      puts output
    end

    def print_clean(clean, whitespaces)
      output = ''
      clean.keys.each_with_index do |key, index|
        output << "Feature #{index+1}:\n" if whitespaces == ''
        statement = key
        output << "#{whitespaces}↳#{statement}\n"
        output << print_clean(clean[key], "#{whitespaces}    ")
      end
      output
    end

    def build_assign_tree(assigns)
      tree = {}
      assigns.each do |assign|
        prev = tree
        assign.each do |ass|
          prev[ass] = {} if prev[ass].nil?
          prev = prev[ass]
        end
      end
      tree
    end
  end
end
