require 'sinatra'
require_relative 'helpers.rb'
require 'pry'

get '/' do
  @data = make_data().sort_by { |line| -line[:clicked].to_i }
  @url = ""
  @resubmit = false
  erb :index
end

post '/' do
  @data = make_data().sort_by { |line| -line[:clicked].to_i }
  @url = fix_url(params["url"])
  if check_dupurl(@url, @data) || check_blank(@url) || check_url(@url)
    @resubmit = true
    erb :index
  else
    save_link(@url, @data)
    @url = ""
    redirect '/'
  end
end

get '/:short' do
  @data = make_data()
  @short = "http://ni.ck/" + params[:short]
  @urlcheck = find_url(@short, @data)
  if @urlcheck
    update_data(@short, @data)
    redirect @urlcheck
  else
    redirect '/'
  end
end
