require 'sinatra'
require 'sinatra/reloader'

enable :sessions

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
end

get '/' do
  slim :index, locals: { dict: DICT }
end

post '/start_game' do
  cleanup_session
  session['difficulty'] = params['difficulty']
  session['secret_word'] = DICT[params[:difficulty].to_i].sample
  redirect '/play'
end

get '/play' do
  slim :play, locals: { difficulty: session['difficulty'], secret_word: session['secret_word'], used_letters: session['used_letters'], message: session['message'] }
end 

post '/guess' do
  session['used_letters'] << params['guess'].strip
  set_message
  gameover?
  redirect '/play'
end

def gameover?
  # player has won if they have no more blanks in their secret word
  uniqs = session['secret_word'].split('')
  if ( uniqs - session['used_letters']) == []
    session['message'] += ' - You Win!'
  end
  # player has lost if they go over the secret word length + 5
end

def cleanup_session
  session['used_letters'] = []
  session['difficulty'] = 5
  session['message'] = nil
  session['guesses'] = 0
end

def set_message
  if session['secret_word'].include? params['guess']
    session['message'] = 'Correct'
  else
    session['message'] = 'Incorrect'
  end
end
