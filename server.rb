require 'sinatra'
require_relative 'helpers.rb'

get '/' do
  @data = make_data()
  @url = ""
  @resubmit = false
  erb :index
end

post '/' do
  @data = make_data()
  @url = fix_url(params["url"])
  if check_dupurl(@url, @data) || check_blank(@url) || check_url(@url)
    @resubmit = true
    @url = ""
    erb :index
  else
    save_link(@url, @data)
    @url = ""
    redirect '/'
  end
end

get '/:short' do
  @data = make_data()
  @short = params[:short]
  @urlcheck = find_url(@short, @data)
  if @urlcheck
    redirect @urlcheck
  else
    redirect '/'
  end
end
