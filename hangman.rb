require 'sinatra'
require 'sinatra/reloader'

configure do
  sorted_dict = {}
  file = File.open('dict.txt','r')
  contents = file.read
  dict_array = contents.split(' ')
  dict_array.each do |word|
    sorted_dict[word.length] = [] unless sorted_dict[word.length].is_a? Array
    sorted_dict[word.length] << word
  end
  DICT = sorted_dict.sort.to_h

  # game tracking variables
  @@used_letters = []
  @@difficulty = 0
end

get '/' do
  slim :index, locals: { dict: DICT }
end

post '/start_game' do
  @@difficulty = params['difficulty']
  @@secret_word = DICT[params[:difficulty].to_i].sample
  redirect '/play'
end

get '/play' do
  slim :play, locals: { difficulty: @@difficulty, secret_word: @@secret_word }
end 
