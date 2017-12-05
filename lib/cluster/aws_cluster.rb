class AWSCluster < Cluster
  def spin_up_nodes
    puts "Brewing up a #{@config['node_count']} pack..."
    ec2 = Aws::EC2::Resource.new
    params = {
        image_id: @config['ami'],
        instance_type: 't2.micro',
        key_name: @config['key'],
        min_count: 1,
        max_count: @config['node_count'],
        iam_instance_profile: {
            arn: @config['ssm_profile']
        }
    }
    instances = ec2.create_instances(params)
      @nodes = instances.map do |ins|
        EC2Node.new(ec2, ins.id, @config)
      end
  end
end