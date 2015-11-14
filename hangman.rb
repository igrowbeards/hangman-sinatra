require 'sinatra'
require 'sinatra/reloader'

get '/' do
  dict = build_dictionary
end

def build_dictionary
  sorted_dict = {}
  file = File.open('dict.txt','r')
  contents = file.read
  dict_array = contents.split(' ')
  dict_array.each do |word|
    sorted_dict[word.length] = [] unless sorted_dict[word.length].is_a? Array
    sorted_dict[word.length] << word
  end
  sorted_dict
end
