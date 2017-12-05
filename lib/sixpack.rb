# Base
require_relative 'cluster/cluster.rb'
require_relative 'node/node.rb'
require_relative 'test.rb'

# AWS
require_relative 'cluster/aws_cluster.rb'
require_relative 'command/ssm_command.rb'
require_relative 'node/ec2_node.rb'
require_relative 'suite_runner/aws_suite_runner.rb'

# Docker-Swarm
require_relative 'cluster/docker_cluster.rb'
require_relative 'command/docker_command.rb'
require_relative 'node/docker_node.rb'
require_relative 'suite_runner/docker_swarm_suite_runner.rb'

require 'time'