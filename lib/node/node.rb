class Node
  attr_reader :id

  def initialize(resource, id, config)
    @resource = resource
    @id = id
    @config = config
    @test = nil
  end
  
  def ready_for_assignment?
    node_up? and (!@test or @test.complete?)
  end
end