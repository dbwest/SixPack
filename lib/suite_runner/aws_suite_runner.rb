require 'yaml'
require 'aws-sdk'

class AWSSuiteRunner

  def initialize(suite)
    @config = YAML.load_file('config/amazon/suites.yaml')[suite]
    # @tests will be replaced with a method to scrape the test suite or db or something
    @tests = ['@test_1', '@test_2', '@test_3', '@test_4', '@test_5', '@test_6', '@test_7', '@test_8', '@test_9']
  end

  def run_suite
    cluster = AWSCluster.new(@config, @tests)
    cluster.assign_tests
    cluster.monitor_nodes
  end

end
