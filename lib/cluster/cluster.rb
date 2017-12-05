class Cluster
  def initialize(config, tests)
    @config = config
    @tests = tests
    spin_up_nodes
  end

  def assign_tests
    @nodes.each do |node|
      node.run_test(@tests.pop) if !@tests.empty? and node.ready_for_assignment?
    end
  end

  def monitor_nodes
    assign_tests until @tests.empty?
    @nodes.reject! {|node| node.destroy} until @nodes.empty?
  end

end
