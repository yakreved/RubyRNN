require './Network'
require 'csv'

describe 'sinus_test' do
  examples = []
  results = []
  rnd = Random.new
  #p "examples"
  200.times do
    r = rnd.rand(Math::PI/4)
    examples << [r]
    results << [Math.sin(r*2)]
  end
  #p results
  #p "/examples"


  nw =Network.new(layers: [1,12,1])
  mse = nw.learn(examples,results,100)

  it "mse should be small" do
    p "mse "+ mse.to_s
    expect(mse).to be < 0.05
  end

  it "result is normal" do
    expect( nw.run(examples[0])[0]).to be_within(0.05).of(results[0][0])
  end
  it "result is normal 2" do
    expect( nw.run(examples[1])[0]).to be_within(0.05).of(results[1][0])
  end
end
