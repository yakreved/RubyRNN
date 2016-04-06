require './Synapse'

class Neuron
  @Synapses
  @OutSynapses
  @Memory
  @MemoryWeigths
  @ActivationFunc
  @result
  @error

  attr_accessor :error

  def result
    @result
  end

  def result= (value)
    @result = value
  end

  def add_out_synapse synapse
    @OutSynapses << synapse
  end

  def initialize prev_layer = nil, memory_size = 0
    @OutSynapses = Array.new
    if(prev_layer!=nil)
      @Synapses = []
      prev_layer.each do |prev_neuron|
        @Synapses  << Synapse.new(prev_neuron,self)
      end
      if(memory_size>0)
        @Memory = Array.new(memory_size){0.0}
        @MemoryWeigths = Array.new(memory_size){Network.random.rand(0.1)}
      end
    end
    @ActivationFunc = {  }
    @ActivationFunc[:F] = self.method :Sigmoid
    @ActivationFunc[:dF] = self.method :dSigmoid
    @learn_speed = 0.1
  end

  def activate
    signal_sum = 0.0
    @Synapses.each { |s| signal_sum+= s.signal }
    if @Memory!= nil
      @CahedMemory = Array.new(@Memory)
      @Memory.each_with_index {|v,i| signal_sum += v*@MemoryWeigths[i]}
      @Memory.pop
      @Memory.insert(0, @ActivationFunc[:F].call(signal_sum))
      if signal_sum.nan? or signal_sum.infinite?
        p self
        raise "fuu"
      end
    end
    @signal_sum = signal_sum
    @result = @ActivationFunc[:F].call(signal_sum)
    @result
  end

  def learn error = nil
    if error == nil
      error = @OutSynapses.inject(0){|sum,s| sum + s.error}
    end
    #p @OutSynapses
    @error = error
    #p error

    @Synapses.each do |s|
      s.weight +=  @learn_speed * @ActivationFunc[:dF].call(@signal_sum)*error* s.input_neuron.result
    end if @Synapses!=nil

    @Memory.each_with_index do |ms,i|
      if @CahedMemory[i].nan? or @CahedMemory[i].infinite?
        p self
        raise "fuu"
      end
      @MemoryWeigths[i] +=  @learn_speed * @ActivationFunc[:dF].call(@signal_sum)*error*@CahedMemory[i]
    end if @Memory!= nil
  end

  def Sigmoid signal
    @C=1
    if signal.nan?
      raise "fuck"
    end
    r = 1/(1+Math.exp(- @C*(signal)))
    if r.nan?
      raise "Fuck"
      return 0.000001
    end
    r
  end

#!!!!!!!!!!!!!!!!!!
  def dSigmoid x
    fx =Sigmoid(x)
    @C*fx*(1.0-fx)
  end

  def Tanh x
    Math.tanh x
  end

  def dTanh x
    1/Math.cosh(x)**2
  end

end
