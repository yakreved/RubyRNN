require 'csv'
require './Network'

data = CSV.read('spec/examples/iris.csv')
data.shuffle!
normalize = -> (val){val.to_f/10}
 answercode = lambda do |ans|
  if(ans == "Iris-setosa")
    return 0.0
  elsif ans == "Iris-versicolor"
    return 0.5
  else
    return 1.0
  end
end

train_data = Array.new
train_answers = Array.new
for i in (0..data.length-11) do
 train_data << data[i][0..data[i].length-2].map { |s| normalize.(s) }
 train_answers <<  [answercode.(data[i].last)]
end

verify_data = Array.new
verify_answers = Array.new
for i in (data.length-10..data.length-1) do
 verify_data << data[i][0..data[i].length-2].map { |s| normalize.(s) }
 verify_answers <<  [answercode.(data[i].last)]
end
nw =Network.new(layers: [4,3,1], learn_speed: 0.1)
mse = nw.learn(train_data, train_answers,100)

p "iris mse "+ mse.to_s

ver_res = nw.verify verify_data, verify_answers

verify_answers.each_with_index do |a,ii|
  p "result  " + ver_res[:output][ii].to_s + " target "+ a.to_s
end
