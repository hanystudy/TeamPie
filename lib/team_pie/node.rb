module TeamPie
  class Node
    attr_accessor :task_name, :type, :index, :key_feature, :dependencies, :start_from_scratch, :leaf
    def initialize(attrs)
      @task_name = attrs[:task_name]
      @type = attrs[:type]
      @index = attrs[:index]
      @key_feature = attrs[:key_feature]
      @dependencies = attrs[:dependencies]
      @start_from_scratch = attrs[:start_from_scratch]
      @leaf = true
    end
  end
end
