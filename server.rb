require 'sinatra'

get '/' do
  @data = make_data()

  erb :index
end

get '/submit' do
  @data = make_data()

  erb :submit
end
