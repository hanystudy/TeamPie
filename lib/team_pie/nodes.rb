module TeamPie
  class Nodes
    INDEX_MAP = {
      task_name: 0,
      type: 1,
      index: 2,
      key_feature: 3,
      dependencies: 4,
      start_from_scratch: 5
    }

    attr_accessor :nodes

    def initialize()
      @nodes = {}
      @tmp_nodes = {}
    end

    def add(row, type)
      index = row[INDEX_MAP[:index]]
      dependencies = row[INDEX_MAP[:dependencies]].to_s.split '|'
      @tmp_nodes["#{type}-#{index}"] = Node.new({
        task_name: row[INDEX_MAP[:task_name]],
        type: row[INDEX_MAP[:type]],
        index: "#{type}-#{index}",
        key_feature: row[INDEX_MAP[:key_feature]],
        dependencies: dependencies,
        start_from_scratch: row[INDEX_MAP[:start_from_scratch]],
      })
    end

    def post_process(type)
      @tmp_nodes.each do |key, node|
        dependencies = node.dependencies.map {|label| "#{type}-#{label}"}
        dependencies.each { |label| @tmp_nodes[label].leaf = false }
        node.dependencies = dependencies
      end
      @nodes.merge! @tmp_nodes
      @tmp_nodes = {}
    end

    def count
      @nodes.count {|key, value| value.leaf}
    end

    def leaves
      @nodes.select {|key, value| value.leaf}.values
    end

    def print_history(index)
      node = @nodes[index]
      result = []
      print(node, result)
      result
    end

    def print(node, histories)
      if node.dependencies.empty?
        histories << [node.task_name]
        return histories
      end
      node.dependencies.each do |dep|
        histories << print(@nodes[dep], []).flatten
      end
      histories.each do |hist|
        hist << node.task_name
      end
      histories
    end
  end
end
