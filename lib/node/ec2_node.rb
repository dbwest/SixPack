class EC2Node < Node
  def run_test(test_id)
    @test = Test.new(test_id, SSMCommand.new(@id, ["cd #{@config['root']}", " bundle exec cucumber -t #{test_id}"]))
  end

  def node_up?
    state == 16 and @resource.client.describe_instance_status({instance_ids: [@id]}).instance_statuses[0].instance_status.details[0].status == 'passed'
  end

  def instance
    @resource.instance(id)
  end

  def state
    instance.state.code
  end

  def destroy
    if ready_for_assignment?
      instance.terminate
      true
    else
      false
    end
  end
end