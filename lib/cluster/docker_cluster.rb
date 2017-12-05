class DockerCluster < Cluster
  def initialize(config, tests)
    Docker.url='tcp://192.168.99.102:2375'
    @master_connection = Docker::Swarm::Connection.new("tcp://192.168.99.102:2375")
    super(config, tests)
  end

  def spin_up_nodes
    puts "Brewing up a #{@config['node_count']} pack..."
    swarm_init_options = {"ListenAddr" => "0.0.0.0:#{@config['listen_port']}", "AdvertiseAddr" => "192.168.99.102:2375"}
    Docker::Swarm::Swarm.leave(true, @master_connection)
    swarm = Docker::Swarm::Swarm.init(swarm_init_options, @master_connection)
    swarm.nodes
    # Create a network which connect services
    network = swarm.create_network_overlay("dav-network")

    # Find all networks in swarm cluster
    networks = swarm.networks()
    # Create a service with n replicas
    service_create_options = {"Name"=>"node",
                              "TaskTemplate" =>
                                  {"ContainerSpec" =>
                                       {"Networks" => [], "Image" => "ruby:2.3-alpine", "Mounts" => [], "User" => "0"},
                                   "Env" => [""],
                                   "LogDriver" => {"Name"=>"json-file", "Options"=>{"max-file"=>"3", "max-size"=>"10M"}},
                                   "Placement" => {},
                                   "Resources" => {"Limits"=>{"MemoryBytes"=>104857600}, "Reservations"=>{}},
                                   "RestartPolicy" => {"Condition"=>"on-failure", "Delay"=>1, "MaxAttempts"=>3}},
                              "Mode"=>{"Replicated" => {"Replicas" => @config['node_count'].to_i}},
                              "UpdateConfig" => {"Delay" => 2, "Parallelism" => 2, "FailureAction" => "pause"},
                              "EndpointSpec"=>
                                  {"Ports" => [{"Protocol"=>"tcp", "PublishedPort" => 8181, "TargetPort" => 80}]},
                              "Labels" => {"layer" => "node"},
                              "Networks" => [{"Target" => "dav-network"}]
    }
    swarm.create_service(service_create_options)
    instances = swarm.find_service_by_name('node').tasks
    @nodes = instances.map do |ins|
      DockerNode.new(swarm, ins.id, @config)
    end
  end
end