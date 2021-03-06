require 'sinatra/reloader'

class HangMan < Sinatra::Base
  enable :sessions

  configure do
    sorted_dict = {}
    file = File.open('dict.txt', 'r')
    contents = file.read
    dict_array = contents.split(' ')
    dict_array.each do |word|
      sorted_dict[word.length] = [] unless sorted_dict[word.length].is_a? Array
      sorted_dict[word.length] << word
    end
    DICT = sorted_dict.sort.to_h

    LOSE_SCORE = 5
  end

  get '/' do
    cleanup_session
    slim :index, locals: { dict: DICT }
  end

  post '/start_game' do
    cleanup_session
    session['difficulty'] = params['difficulty']
    session['secret_word'] = DICT[params[:difficulty].to_i].sample
    redirect '/play'
  end

  get '/play' do
    redirect_unless_gamestarted
    slim :play, locals: {
      difficulty: session['difficulty'],
      secret_word: session['secret_word'],
      used_letters: session['used_letters'],
      message: session['message'],
      gameover: session['gameover'],
      incorrect: session['incorrect']
    }
  end

  post '/guess' do
    session['used_letters'] << params['guess'].strip
    unless session['secret_word'].include? params['guess']
      session['incorrect'] += 1
    end
    gameover?
    redirect '/play'
  end

  private

  def redirect_unless_gamestarted
    redirect '/' if session['difficulty'].nil?
  end

  def gameover?
    # player has won if they have no more blanks in their secret word
    uniqs = session['secret_word'].split('')
    if (uniqs - session['used_letters']) == []
      session['gameover'] = true
      session['message'] = 'You Win!'
    # player has lost if they have guessed incorrectly 6 times
    elsif session['incorrect'] >= LOSE_SCORE
      session['gameover'] = true
      session['message'] = 'You Lose!'
    end
  end

  def cleanup_session
    session['used_letters'] = []
    session['difficulty'] = nil
    session['message'] = nil
    session['incorrect'] = 0
    session['gameover'] = false
  end
end
