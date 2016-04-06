require './Neuron'

class Network
    @@random = Random.new

  def initialize(params={})
    layers = params.fetch(:layers,[1,1])
    memory_size = params.fetch(:memory_size,0)
    @accurancy = params.fetch(:accurancy, 0.0005)
    @layers = []
    layers.each_with_index do |l,i|
      if i==0
        @layers << Array.new(l){Neuron.new(nil,memory_size)}
      else
        @layers << Array.new(l){Neuron.new(@layers[i-1],memory_size)}
      end
    end
  end

  def self.random
    @@random
  end

  def run inputs
    @layers.each_with_index do |l,i|
      if i==0
        l.each {|n| n.result = inputs[i]}
      elsif i == @layers.length-1
       l.each {|n| n.activate}
       return  l.map { |n| n.result }
      else
        l.each {|n| n.activate}
      end
    end
  end


    def learn examples, results, times = 1
      mse =0
      times.times do
        err_sum = 0.0
        examples.each_with_index do |example,i|
          res = run example
          err_sum += mean_squared_error(res,results[i])
          @layers.last.each_with_index { |n,j| n.learn( results[i][j] - res[j])}
          @layers.reverse[1..-1].each {|l| l.each{|n| n.learn}}
        end
        mse = (err_sum/results.length)
        if mse < @accurancy
          return mse
        end
        #p "mse "+ mse.to_s
      end
      mse
    end

    def verify examples, results
      err_sum = 0
      network_output = Array.new
      examples.each_with_index do |example,i|
        res = run example
        network_output << res
        err_sum+= mean_squared_error results[i], res
      end
      {mse: err_sum/examples.length, output: network_output}
    end


    def mean_squared_error target, fact
      mse = 0.0
      fact.each_with_index do |v,i|
        mse += (v-target[i]).abs
      end
      mse/= fact.length
    end
end
