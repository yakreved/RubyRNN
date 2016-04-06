require './Network'
require 'csv'

require 'rchart'

data = CSV.read('spec/examples/curr.csv')
data = data.map { |row| row[5] }

normalize = -> (val){val.to_f/100}
train_data = Array.new
train_answers = Array.new
for i in (0..data.length-21) do
  train_data << [normalize.(data[i])]
  train_answers <<  [normalize.(data[i+1])]
end

test_data = Array.new
test_answers = Array.new
for i in (data.length-20..data.length-2) do
  test_data << [normalize.(data[i])]
  test_answers <<  [normalize.(data[i+1])]
end

p "start learning"
nw =Network.new(layers: [1,20,10,1],memory_size:15, learn_speed: 0.1)
mse = nw.learn(train_data, train_answers,1000)
p "end learning with mse "+ mse.to_s

verify_res = nw.verify test_data, test_answers
p "verification error "+ verify_res[:mse].to_s

test_answers.each_with_index do |targetres,ii|
  p "target res " + targetres.to_s + "  res "+ verify_res[:output][ii].to_s
end

p = Rdata.new
p.add_point(test_answers.flatten(1).compact,"Origin")
p.add_point(verify_res[:output].flatten(1).compact,"Predicted")
p.add_all_series()
p.set_abscise_label_serie
p.set_serie_name("January","Origin")
p.set_serie_name("February","Predicted")
ch = Rchart.new(700,500)
        ch.set_graph_area(50,30,585,400)
ch.draw_scale(p.get_data,p.get_data_description,Rchart::SCALE_NORMAL,150,150,150,true,0,2,true)
ch.draw_grid(4,true,230,230,230,50)
ch.draw_line_graph(p.get_data,p.get_data_description)
ch.draw_plot_graph(p.get_data, p.get_data_description,3,2,255,255,255)
ch.render_png("basic-line-plot.png")
