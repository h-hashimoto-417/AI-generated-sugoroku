require "json"

file_path = "sample.json"

json_string = File.read(file_path)
data = JSON.parse(json_string)

data_title = data["title"]
data_squares = data["squares"]

data_count = data_squares.length

puts data_title
puts "マス数：#{data_count}個"

data_squares.each_with_index do |square, index|
  puts "#{index+1}マス目: [#{square['type']}] #{square['text']}"
  puts "  -> 効果: #{square['effect']}, 値: #{square['value']}"
end