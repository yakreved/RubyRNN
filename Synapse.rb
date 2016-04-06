class Synapse
  @input_neuron
  @current_neuron
  @weight

  attr_accessor :prev_weight, :current_neuron, :input_neuron

  def initialize(inn,curr)
    @weight = Network.random.rand(0.1)
    @input_neuron = inn
    @current_neuron = curr
    inn.add_out_synapse self
  end

  def weight
    @weight
  end

  def weight= w
    @prev_weight = @weight
    @weight = w
  end

  def signal
    @weight* @input_neuron.result
  end

  def error
    @prev_weight * @current_neuron.error
  end
end
